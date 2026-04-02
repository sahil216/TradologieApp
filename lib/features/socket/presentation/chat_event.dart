import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

class ChatConnectEvent extends ChatEvent {
  final String userId;
  final String role; // "Seller", "Buyer", etc.
  const ChatConnectEvent(this.userId, {this.role = ""});

  @override
  List<Object?> get props => [userId, role];
}

class ChatDisconnectEvent extends ChatEvent {
  const ChatDisconnectEvent();
}

class ChatSendMessageEvent extends ChatEvent {
  final String toUser;
  final String message;
  const ChatSendMessageEvent({required this.toUser, required this.message});

  @override
  List<Object?> get props => [toUser, message];
}

class ChatSendImageEvent extends ChatEvent {
  final String toUser;
  final File file;
  final bool fromCamera;
  const ChatSendImageEvent({
    required this.toUser,
    required this.file,
    this.fromCamera = false,
  });

  @override
  List<Object?> get props => [toUser, file.path, fromCamera];
}

class ChatSendPdfEvent extends ChatEvent {
  final String toUser;
  final File file;
  const ChatSendPdfEvent({required this.toUser, required this.file});

  @override
  List<Object?> get props => [toUser, file.path];
}

class ChatSendVoiceEvent extends ChatEvent {
  final String toUser;
  final File file;
  final Duration duration;
  const ChatSendVoiceEvent({
    required this.toUser,
    required this.file,
    required this.duration,
  });

  @override
  List<Object?> get props => [toUser, file.path, duration];
}

class ChatMessageReceivedEvent extends ChatEvent {
  final ChatMessage message;
  const ChatMessageReceivedEvent(this.message);

  @override
  List<Object?> get props => [message];
}

class ChatConnectionChangedEvent extends ChatEvent {
  final bool isConnected;
  const ChatConnectionChangedEvent(this.isConnected);

  @override
  List<Object?> get props => [isConnected];
}

class ChatTypingEvent extends ChatEvent {
  final String toUser;
  const ChatTypingEvent(this.toUser);

  @override
  List<Object?> get props => [toUser];
}

class ChatUserTypingEvent extends ChatEvent {
  final String userId;
  const ChatUserTypingEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class ChatStartRecordingEvent extends ChatEvent {
  const ChatStartRecordingEvent();
}

class ChatStopRecordingEvent extends ChatEvent {
  final String toUser;
  const ChatStopRecordingEvent(this.toUser);

  @override
  List<Object?> get props => [toUser];
}

class ChatCancelRecordingEvent extends ChatEvent {
  const ChatCancelRecordingEvent();
}

class ChatRecordingTickEvent extends ChatEvent {
  final Duration duration;
  const ChatRecordingTickEvent(this.duration);

  @override
  List<Object?> get props => [duration];
}

class ChatUpdateMessageEvent extends ChatEvent {
  final ChatMessage message;
  const ChatUpdateMessageEvent(this.message);

  @override
  List<Object?> get props => [message];
}
