import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatConnecting extends ChatState {
  const ChatConnecting();
}

class ChatConnected extends ChatState {
  final List<ChatMessageModel> messages;
  final bool isTyping;
  final String typingUserId;
  final bool isRecording;
  final Duration recordingDuration;
  final double uploadProgress;

  const ChatConnected({
    this.messages = const [],
    this.isTyping = false,
    this.typingUserId = '',
    this.isRecording = false,
    this.recordingDuration = Duration.zero,
    this.uploadProgress = 0.0,
  });

  ChatConnected copyWith({
    List<ChatMessageModel>? messages,
    bool? isTyping,
    String? typingUserId,
    bool? isRecording,
    Duration? recordingDuration,
    double? uploadProgress,
  }) {
    return ChatConnected(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
      typingUserId: typingUserId ?? this.typingUserId,
      isRecording: isRecording ?? this.isRecording,
      recordingDuration: recordingDuration ?? this.recordingDuration,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }

  @override
  List<Object?> get props => [
        messages,
        isTyping,
        typingUserId,
        isRecording,
        recordingDuration,
        uploadProgress,
      ];
}

class ChatDisconnected extends ChatState {
  final String? reason;
  const ChatDisconnected({this.reason});

  @override
  List<Object?> get props => [reason];
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);

  @override
  List<Object?> get props => [message];
}
