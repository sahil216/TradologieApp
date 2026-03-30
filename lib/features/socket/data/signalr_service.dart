import 'dart:async';

import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import 'package:signalr_netcore/itransport.dart';
import 'package:tradologie_app/features/socket/presentation/chat_view_model.dart';

class SignalRService {
  HubConnection? hub;

  String baseUrl = "https://connect.tradologie.com";
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
        .build();

    // ✅ RECEIVE MESSAGE
    hub!.on("receiveMessage", (args) {
      final user = args![0] as String;
      final message = args[1] as String;

      _messageController.add(ChatMessage(user, message));
    });

    await hub!.start();
    await hub!.invoke("Connect", args: [userId]);

    _connectionController.add(true);
  }

  Future<void> sendMessage(String toUser, String message) async {
    await hub!.invoke("SendMessage", args: [myUserId, toUser, message]);
  }

  void dispose() {
    _messageController.close();
    _connectionController.close();
  }
}
