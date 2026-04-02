import 'dart:async';
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

  final _messageController = StreamController<ChatMessageModel>.broadcast();
  Stream<ChatMessageModel> get messageStream => _messageController.stream;

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
    /// RECEIVE TEXT MESSAGE
    /// ===========================
    hub!.on("receiveMessage", (arguments) {
      try {
        if (arguments == null || arguments.isEmpty) return;

        if (arguments[0] is Map) {
          final data = arguments[0] as Map;
          final message = ChatMessageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fromUserId: data["fromUserId"] ?? "",
            message: data["message"] ?? "",
            type: MessageType.text,
            timestamp: DateTime.now(),
          );
          _messageController.add(message);
        } else if (arguments.length >= 2) {
          final fromUser = arguments[0]?.toString() ?? "";
          final messageText = arguments[1]?.toString() ?? "";
          _messageController.add(ChatMessageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fromUserId: fromUser,
            message: messageText,
            type: MessageType.text,
            timestamp: DateTime.now(),
          ));
        }
      } catch (e) {
        print("Receive message error: $e");
      }
    });

    /// ===========================
    /// RECEIVE FILE/ATTACHMENT
    /// ===========================
    hub!.on("receiveFile", (arguments) {
      try {
        if (arguments == null || arguments.isEmpty) return;

        if (arguments[0] is Map) {
          final data = arguments[0] as Map;
          final rawType = data["fileType"]?.toString() ?? "file";
          final type = _parseMessageType(rawType);
          final message = ChatMessageModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            fromUserId: data["fromUserId"] ?? "",
            message: data["fileName"] ?? "Attachment",
            type: type,
            attachmentUrl: data["fileUrl"],
            fileName: data["fileName"],
            fileSize: data["fileSize"] != null
                ? int.tryParse(data["fileSize"].toString())
                : null,
            duration: data["duration"] != null
                ? Duration(
                    seconds: int.tryParse(data["duration"].toString()) ?? 0)
                : null,
            timestamp: DateTime.now(),
          );
          _messageController.add(message);
        }
      } catch (e) {
        print("Receive file error: $e");
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

  Future<void> sendMessage(String toUser, String message) async {
    if (hub?.state == HubConnectionState.Connected) {
      await hub!.invoke(
        "SendMessage",
        args: [myUserId, toUser, message],
      );
    }
  }

  Future<void> sendFile({
    required String toUser,
    required File file,
    required String fileType,
    String? fileName,
    int? duration,
  }) async {
    if (hub?.state == HubConnectionState.Connected) {
      final bytes = await file.readAsBytes();
      final base64 = _encodeBase64(bytes);
      await hub!.invoke(
        "SendFile",
        args: [
          myUserId,
          toUser,
          base64,
          fileType,
          fileName ?? file.path.split('/').last,
          bytes.length,
          if (duration != null) duration,
        ],
      );
    }
  }

  Future<void> sendTyping(String toUser) async {
    if (hub?.state == HubConnectionState.Connected) {
      await hub!.invoke("Typing", args: [myUserId, toUser]);
    }
  }

  String _encodeBase64(List<int> bytes) {
    const base64Chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    var result = '';
    for (var i = 0; i < bytes.length; i += 3) {
      final b0 = bytes[i];
      final b1 = i + 1 < bytes.length ? bytes[i + 1] : 0;
      final b2 = i + 2 < bytes.length ? bytes[i + 2] : 0;
      result += base64Chars[(b0 >> 2) & 0x3F];
      result += base64Chars[((b0 & 0x03) << 4) | ((b1 >> 4) & 0x0F)];
      result += i + 1 < bytes.length
          ? base64Chars[((b1 & 0x0F) << 2) | ((b2 >> 6) & 0x03)]
          : '=';
      result += i + 2 < bytes.length ? base64Chars[b2 & 0x3F] : '=';
    }
    return result;
  }

  MessageType _parseMessageType(String type) {
    switch (type.toLowerCase()) {
      case 'image':
        return MessageType.image;
      case 'pdf':
        return MessageType.pdf;
      case 'audio':
      case 'voice':
        return MessageType.voice;
      case 'video':
        return MessageType.video;
      default:
        return MessageType.file;
    }
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
