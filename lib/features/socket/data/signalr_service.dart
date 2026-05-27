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
  final String baseUrl = "https://chat.tradologie.com";

  String myUserId = "";

  /// The role of the current user as expected by the backend: "Seller", "Buyer", etc.
  String senderRole = "";

  String _activeOtherUserId = '';

  // final _messageController = StreamController<ChatMessage>.broadcast();
  // Stream<ChatMessage> get messageStream => _messageController.stream;

  // final _connectionController = StreamController<bool>.broadcast();
  // Stream<bool> get connectionStream => _connectionController.stream;

  // final _typingController = StreamController<String>.broadcast();
  // Stream<String> get typingStream => _typingController.stream;

  StreamController<ChatMessage> _messageController =
      StreamController<ChatMessage>.broadcast();
  StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  StreamController<String> _typingController =
      StreamController<String>.broadcast();

  Stream<ChatMessage> get messageStream => _messageController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  Stream<String> get typingStream => _typingController.stream;

  void _ensureControllersOpen() {
    if (_messageController.isClosed) {
      _messageController = StreamController<ChatMessage>.broadcast();
    }
    if (_connectionController.isClosed) {
      _connectionController = StreamController<bool>.broadcast();
    }
    if (_typingController.isClosed) {
      _typingController = StreamController<String>.broadcast();
    }
  }

  Future<void> _invokeSetActiveChat(
    String currentUserId,
    String otherUserId,
  ) async {
    final active = hub;
    if (active == null || active.state != HubConnectionState.Connected) {
      return;
    }
    final otherId = otherUserId.trim();
    if (otherId.isEmpty) return;
    await active.invoke(
      'SetActiveChat',
      args: [currentUserId.toString(), otherId],
    );
  }

  Future<void> connect(
    String userId, {
    String role = '',
    String otherUserId = '',
  }) async {
    _ensureControllersOpen();

    myUserId = userId;
    senderRole = role;
    _activeOtherUserId = otherUserId.trim();

    hub = HubConnectionBuilder()
        .withUrl(
          "$baseUrl/chathub",
          options: HttpConnectionOptions(
            transport: HttpTransportType.WebSockets,
          ),
        )
        .withAutomaticReconnect()
        .build();

    hub!.on("receiveMessage", (arguments) {
      // ... your existing handler
    });

    hub!.onclose(({Exception? error}) {
      if (!_connectionController.isClosed) {
        _connectionController.add(false);
      }
    });

    hub!.onreconnected(({String? connectionId}) async {
      if (!_connectionController.isClosed) {
        _connectionController.add(true);
      }
      await hub!.invoke('Connect', args: [userId]);
      await _invokeSetActiveChat(userId, _activeOtherUserId);
    });

    await hub!.start();
    await hub!.invoke('Connect', args: [userId]);
    await _invokeSetActiveChat(userId, _activeOtherUserId);

    if (!_connectionController.isClosed) {
      _connectionController.add(true);
    }
  }

  /// Marks this conversation active on the server (read/unread, routing).
  Future<void> setActiveChat(String currentUserId, String otherUserId) {
    _activeOtherUserId = otherUserId.trim();
    return _invokeSetActiveChat(currentUserId, otherUserId);
  }

  /// Clears active chat when leaving (server uses `0` as none).
  Future<void> clearActiveChat() {
    if (myUserId.trim().isEmpty) return Future.value();
    return _invokeSetActiveChat(myUserId, '0');
  }

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
    try {
      await clearActiveChat();
    } catch (_) {}
    await hub?.stop();

    // Guard before adding to a potentially closed stream
    if (!_connectionController.isClosed) {
      _connectionController.add(false);
    }
  }

  Future<void> dispose() async {
    await hub?.stop();

    if (!_messageController.isClosed) _messageController.close();
    if (!_connectionController.isClosed) _connectionController.close();
    if (!_typingController.isClosed) _typingController.close();

    hub = null;
  }
}
