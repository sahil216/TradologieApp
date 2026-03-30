import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  late HubConnection _connection;

  Function(String user, String message)? onMessageReceived;

  Future<void> connect(String token, String userId) async {
    _connection = HubConnectionBuilder()
        .withUrl(
          "https://connect.tradologie.com/signalr",
          options: HttpConnectionOptions(
            transport: HttpTransportType.WebSockets,
            accessTokenFactory: () async => token,
          ),
        )
        .withAutomaticReconnect()
        .build();

    /// 🔥 RECEIVE MESSAGE
    _connection.on("receiveMessage", (args) {
      if (args != null && args.length >= 2) {
        final user = args[0].toString();
        final message = args[1].toString();

        onMessageReceived?.call(user, message);
      }
    });

    /// ✅ FIXED CALLBACK SIGNATURES
    _connection.onclose(({Exception? error}) {
      print("❌ Connection closed: $error");
    });

    _connection.onreconnecting(({Exception? error}) {
      print("🔄 Reconnecting...");
    });

    _connection.onreconnected(({String? connectionId}) {
      print("✅ Reconnected");
    });

    /// 🚀 START CONNECTION
    await _connection.start();

    print("✅ Connected");

    /// 👤 CONNECT USER (IMPORTANT)
    await _connection.invoke("Connect", args: [userId]);
  }

  /// 📤 SEND MESSAGE
  Future<void> sendMessage(
      String fromUser, String toUser, String message) async {
    if (_connection.state != HubConnectionState.Connected) {
      print("❌ Not connected yet");
      return;
    }

    await _connection.invoke(
      "SendMessage",
      args: [fromUser, toUser, message],
    );
  }

  Future<void> disconnect() async {
    await _connection.stop();
  }
}
