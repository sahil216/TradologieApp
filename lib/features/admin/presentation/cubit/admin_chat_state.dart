import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';

abstract class AdminChatState extends Equatable {
  const AdminChatState();

  @override
  List<Object?> get props => [];
}

class AdminChatInitial extends AdminChatState {
  const AdminChatInitial();
}

class AdminChatConnecting extends AdminChatState {
  final List<ChatMessage> messages;

  const AdminChatConnecting({this.messages = const []});

  @override
  List<Object?> get props => [messages];
}

class AdminChatConnected extends AdminChatState {
  final List<ChatMessage> messages;
  final bool isSending;

  const AdminChatConnected({
    this.messages = const [],
    this.isSending = false,
  });

  AdminChatConnected copyWith({
    List<ChatMessage>? messages,
    bool? isSending,
  }) {
    return AdminChatConnected(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object?> get props => [messages, isSending];
}

class AdminChatDisconnected extends AdminChatState {
  final String? reason;
  final List<ChatMessage> messages;

  const AdminChatDisconnected({
    this.reason,
    this.messages = const [],
  });

  @override
  List<Object?> get props => [reason, messages];
}

class AdminChatError extends AdminChatState {
  final String message;

  const AdminChatError(this.message);

  @override
  List<Object?> get props => [message];
}
