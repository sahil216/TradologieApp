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

  Future<void> sendMessage({
    required String toUser,
    required String message,
    String? file,
    String? fileType,
  }) async {
    await _service.sendMessage(
      toUser: toUser,
      message: message,
      file: file,
      fileType: fileType,
    );

    emit([
      ...state,
      ChatMessage(
        user: "me",
        message: message,
        file: file,
        fileType: fileType,
        type: "Seller",
      )
    ]);
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
  final String? file;
  final String? fileType;
  final String? type;

  ChatMessage({
    required this.user,
    required this.message,
    this.file,
    this.fileType,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      "fromUserId": user,
      "message": message,
      "file": file,
      "fileType": fileType,
      "type": type,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      user: json["fromUserId"] ?? "",
      message: json["message"] ?? "",
      file: json["file"],
      fileType: json["fileType"],
      type: json["type"],
    );
  }
}
