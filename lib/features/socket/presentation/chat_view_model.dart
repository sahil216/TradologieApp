import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/features/socket/data/signalr_service.dart';

class ChatsCubit extends Cubit<List<ChatMessage>> {
  final SignalRService _service;
  StreamSubscription? _msgSub;

  ChatsCubit(this._service) : super([]);

  Future<void> connect(String userId) async {
    await _service.connect(userId);

    // ✅ Listen to messages
    _msgSub = _service.messageStream.listen((msg) {
      emit([...state, msg]);
    });
  }

  Future<void> sendMessage(String toUser, String message) async {
    await _service.sendMessage(toUser, message);

    // Optimistic update
    emit([...state, ChatMessage("me", message)]);
  }

  @override
  Future<void> close() {
    _msgSub?.cancel();
    _service.dispose();
    return super.close();
  }
}

class ChatMessage {
  final String user;
  final String message;
  ChatMessage(this.user, this.message);
}
