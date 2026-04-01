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

        /// Case 1: Backend sends JSON object
        if (arguments[0] is Map) {
          final data = arguments[0] as Map;

          final message = ChatMessage(
            data["fromUserId"],
            data["message"],
          );

          _messageController.add(message);
        }

        /// Case 2: Backend sends multiple params
        else if (arguments.length >= 2) {
          final fromUser = arguments[0]?.toString() ?? "";
          final messageText = arguments[1]?.toString() ?? "";

          _messageController.add(
            ChatMessage(fromUser, messageText),
          );
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

  Future<void> sendMessage(String toUser, String message) async {
    if (hub?.state == HubConnectionState.Connected) {
      await hub!.invoke(
        "SendMessage",
        args: [myUserId, toUser, message],
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
