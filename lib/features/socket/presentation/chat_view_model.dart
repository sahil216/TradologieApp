import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/features/socket/data/signalr_service.dart';
import 'package:tradologie_app/features/socket/domain/message_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatMessage {
  final String user;
  final String message;

  ChatMessage(this.user, this.message);
}

class ChatsCubit extends Cubit<List<ChatMessage>> {
  final SignalRService _service;

  ChatsCubit(this._service) : super([]);

  Future<void> connect(String token, String userId) async {
    await _service.connect(token, userId);

    _service.onMessageReceived = (user, message) {
      emit([...state, ChatMessage(user, message)]);
    };
  }

  Future<void> sendMessage(
      String fromUser, String toUser, String message) async {
    await _service.sendMessage(fromUser, toUser, message);

    emit([...state, ChatMessage(fromUser, message)]);
  }

//   Future<List<ChatMessage>> getChatHistory() async {
//   final response = await http.get(
//     Uri.parse(
//       "http://yourserver/api/chat/history?fromUserId=1&toUserId=2",
//     ),
//   );

//   final data = jsonDecode(response.body);

//   return (data as List)
//       .map((e) => ChatMessage(e['user'], e['message']))
//       .toList();
// }
}

class ChatState {
  final List<Message> messages;
  final bool isConnected;

  ChatState({
    required this.messages,
    required this.isConnected,
  });

  factory ChatState.initial() => ChatState(messages: [], isConnected: false);
}
