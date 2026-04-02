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
  final String baseUrl = "http://connect.tradologie.com";
  String myUserId = "";

  final _messageController = StreamController<ChatMessage>.broadcast();
  Stream<ChatMessage> get messageStream => _messageController.stream;

  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  final _typingController = StreamController<String>.broadcast();
  Stream<String> get typingStream => _typingController.stream;

  Future<void> connect(String userId) async {
    myUserId = userId;

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

        ChatMessage? message;

        if (arguments[0] is Map) {
          // Backend sends a JSON object
          message = ChatMessage.fromJson(
            Map<String, dynamic>.from(arguments[0] as Map),
          );
        } else if (arguments.length >= 2) {
          // Backend sends multiple positional params
          message = ChatMessage(
            user: arguments[0]?.toString() ?? "",
            message: arguments[1]?.toString() ?? "",
            type: "text",
          );
        }

        if (message != null) _messageController.add(message);
      } catch (e) {
        print("receiveMessage error: $e");
      }
    });

    /// ===========================
    /// RECEIVE FILE / ATTACHMENT
    /// ===========================
    hub!.on("receiveFile", (arguments) {
      try {
        if (arguments == null || arguments.isEmpty) return;

        if (arguments[0] is Map) {
          final data = Map<String, dynamic>.from(arguments[0] as Map);
          // Map server file payload into ChatMessage
          final message = ChatMessage(
            user: data["fromUserId"] ?? "",
            message: data["fileName"] ?? "Attachment",
            file: data["fileUrl"],
            fileType: data["fileType"],
            type: "file",
          );
          _messageController.add(message);
        }
      } catch (e) {
        print("receiveFile error: $e");
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

  /// Send a plain text message
  Future<void> sendMessage(String toUser, String message) async {
    if (hub?.state != HubConnectionState.Connected) return;

    final payload = ChatMessage(
      user: myUserId,
      message: message,
      type: "text",
    );

    await hub!.invoke(
      "SendMessage",
      args: [myUserId, toUser, message],
    );
  }

  /// Send an image (camera or gallery)
  Future<void> sendImage({
    required String toUser,
    required File file,
    required String fileType, // "image"
    String? fileName,
  }) async {
    if (hub?.state != HubConnectionState.Connected) return;

    final bytes = await file.readAsBytes();
    final base64Data = base64Encode(bytes);
    final name = fileName ?? file.path.split('/').last;

    final payload = ChatMessage(
      user: myUserId,
      message: name,
      file: base64Data,
      fileType: fileType,
      type: "file",
    );

    await hub!.invoke("SendFile", args: [payload.toJson(), toUser]);
  }

  /// Send a PDF
  Future<void> sendPdf({
    required String toUser,
    required File file,
    String? fileName,
  }) async {
    if (hub?.state != HubConnectionState.Connected) return;

    final bytes = await file.readAsBytes();
    final base64Data = base64Encode(bytes);
    final name = fileName ?? file.path.split('/').last;

    final payload = ChatMessage(
      user: myUserId,
      message: name,
      file: base64Data,
      fileType: "pdf",
      type: "file",
    );

    await hub!.invoke("SendFile", args: [payload.toJson(), toUser]);
  }

  /// Send a voice recording
  Future<void> sendVoice({
    required String toUser,
    required File file,
    required Duration duration,
  }) async {
    if (hub?.state != HubConnectionState.Connected) return;

    final bytes = await file.readAsBytes();
    final base64Data = base64Encode(bytes);

    final payload = ChatMessage(
      user: myUserId,
      message: "Voice message (${_formatDuration(duration)})",
      file: base64Data,
      fileType: "audio",
      type: "file",
    );

    await hub!.invoke("SendFile", args: [payload.toJson(), toUser]);
  }

  // Future<void> sendTyping(String toUser) async {
  //   if (hub?.state == HubConnectionState.Connected) {
  //     await hub!.invoke("Typing", args: [myUserId, toUser]);
  //   }
  // }

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
