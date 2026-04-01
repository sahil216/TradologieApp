import 'dart:async';
import 'dart:convert';

import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:tradologie_app/features/socket/presentation/chat_view_model.dart';

class SignalRService {
  HubConnection? hub;

  final String baseUrl = "http://connect.tradologie.com";
  String myUserId = "";

  final _messageController = StreamController<ChatMessage>.broadcast();
  Stream<ChatMessage> get messageStream => _messageController.stream;

  final _connectionController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  Future<void> connect(String userId) async {
    myUserId = userId;

    hub = HubConnectionBuilder()
        .withUrl(
          "$baseUrl/chathub",
          options: HttpConnectionOptions(
            transport: HttpTransportType.WebSockets,
          ),
        )
        .withAutomaticReconnect() // ✅ Auto reconnect
        .build();

    /// ===========================
    /// RECEIVE MESSAGE
    /// ===========================
    hub!.on("receiveMessage", (arguments) {
      try {
        if (arguments == null || arguments.isEmpty) return;

        final raw = arguments[0];

        if (raw is Map) {
          final data = Map<String, dynamic>.from(raw);

          final message = ChatMessage.fromJson(data);
          _messageController.add(message);
        }

        /// If backend sends JSON string
        else if (raw is String) {
          final decoded = jsonDecode(raw);
          final data = Map<String, dynamic>.from(decoded);

          final message = ChatMessage.fromJson(data);
          _messageController.add(message);
        }
      } catch (e) {
        print("Receive message error: $e");
      }
    });

    /// ===========================
    /// CONNECTION EVENTS
    /// ===========================
    // hub!.onclose((error) {
    //   _connectionController.add(false);
    // });

    // hub!.onreconnected((connectionId) {
    //   _connectionController.add(true);
    // });

    await hub!.start();

    /// Register user on server
    await hub!.invoke("Connect", args: [userId]);

    _connectionController.add(true);
  }

  Future<void> sendMessage({
    required String toUser,
    required String message,
    String? file,
    String? fileType,
    String type = "Seller",
  }) async {
    if (hub?.state == HubConnectionState.Connected) {
      final messageObj = {
        "message": message,
        "file": file,
        "fileType": fileType,
        "type": type,
      };

      await hub!.invoke(
        "SendMessage",
        args: [myUserId, toUser, messageObj],
      );
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
  }
}
