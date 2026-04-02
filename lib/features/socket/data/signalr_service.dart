import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';

class SignalRService {
  HubConnection? hub;
  final String baseUrl = "https://connect.tradologie.com";

  String myUserId = "";

  /// The role of the current user as expected by the backend: "Seller", "Buyer", etc.
  String senderRole = "";

  final _messageController = StreamController<ChatMessage>.broadcast();
  Stream<ChatMessage> get messageStream => _messageController.stream;

  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  final _typingController = StreamController<String>.broadcast();
  Stream<String> get typingStream => _typingController.stream;

  Future<void> connect(String userId, {String role = ""}) async {
    myUserId = userId;
    senderRole = role;

    hub = HubConnectionBuilder()
        .withUrl(
          "$baseUrl/chathub",
          options: HttpConnectionOptions(
            transport: HttpTransportType.WebSockets,
          ),
        )
        .withAutomaticReconnect()
        .build();

    /// ===========================
    /// RECEIVE MESSAGE
    /// ===========================
    hub!.on("receiveMessage", (arguments) {
      try {
        if (arguments == null || arguments.isEmpty) return;

        ChatMessage? msg;

        if (arguments[0] is Map) {
          // BE sends full object: { fromUserId, message, file, fileType, type }
          msg = ChatMessage.fromJson(
              Map<String, dynamic>.from(arguments[0] as Map));
        } else if (arguments.length >= 2) {
          // BE sends positional args
          msg = ChatMessage(
            user: arguments[0]?.toString() ?? "",
            message: arguments[1]?.toString() ?? "",
          );
        }

        if (msg != null) _messageController.add(msg);
      } catch (e) {
        print("receiveMessage error: $e");
      }
    });

    /// ===========================
    /// TYPING INDICATOR
    /// ===========================
    hub!.on("userTyping", (arguments) {
      if (arguments != null && arguments.isNotEmpty) {
        _typingController.add(arguments[0]?.toString() ?? "");
      }
    });

    hub!.onclose(({Exception? error}) {
      _connectionController.add(false);
    });

    hub!.onreconnected(({String? connectionId}) {
      _connectionController.add(true);
      hub!.invoke("Connect", args: [userId]);
    });

    await hub!.start();
    await hub!.invoke("Connect", args: [userId]);
    _connectionController.add(true);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SEND — all methods build a ChatMessage and send .toJson() to the hub
  // Matches the BE object shape:
  //   { fromUserId, message, file, fileType, type }
  //   where type = sender role ("Seller" / "Buyer")
  // ─────────────────────────────────────────────────────────────────────────

  /// Plain text message
  Future<void> sendMessage(String toUser, ChatMessage chatMessage) async {
    if (hub?.state != HubConnectionState.Connected) return;
    await hub!
        .invoke("SendMessage", args: [myUserId, toUser, chatMessage.toJson()]);
  }

  /// Image from camera or gallery
  /// [mimeType] should be the actual MIME e.g. "image/png", "image/jpeg"
  Future<void> sendImage({
    required String toUser,
    required File file,
    String mimeType = "image/jpeg",
    String? fileName,
  }) async {
    if (hub?.state != HubConnectionState.Connected) return;

    final bytes = await file.readAsBytes();
    final payload = ChatMessage(
      user: myUserId,
      message: fileName ?? file.path.split('/').last,
      file: base64Encode(bytes),
      fileType: mimeType, // e.g. "image/png"
      type: senderRole, // e.g. "Seller"
    );

    await hub!.invoke("SendFile", args: [payload.toJson(), toUser]);
  }

  /// PDF document
  Future<void> sendPdf({
    required String toUser,
    required File file,
    String? fileName,
  }) async {
    if (hub?.state != HubConnectionState.Connected) return;

    final bytes = await file.readAsBytes();
    final payload = ChatMessage(
      user: myUserId,
      message: fileName ?? file.path.split('/').last,
      file: base64Encode(bytes),
      fileType: "application/pdf", // standard MIME
      type: senderRole,
    );

    await hub!.invoke("SendFile", args: [payload.toJson(), toUser]);
  }

  /// Voice recording
  Future<void> sendVoice({
    required String toUser,
    required File file,
    required Duration duration,
  }) async {
    if (hub?.state != HubConnectionState.Connected) return;

    final bytes = await file.readAsBytes();
    final payload = ChatMessage(
      user: myUserId,
      message: "Voice message (${_formatDuration(duration)})",
      file: base64Encode(bytes),
      fileType: "audio/m4a", // standard MIME for AAC/m4a
      type: senderRole,
      duration: duration,
    );

    await hub!.invoke("SendFile", args: [payload.toJson(), toUser]);
  }

  Future<void> sendTyping(String toUser) async {
    if (hub?.state == HubConnectionState.Connected) {
      await hub!.invoke("Typing", args: [myUserId, toUser]);
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  Future<void> disconnect() async {
    await hub?.stop();
    _connectionController.add(false);
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _connectionController.close();
    _typingController.close();
  }
}
