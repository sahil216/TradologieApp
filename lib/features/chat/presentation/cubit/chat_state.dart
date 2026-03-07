part of 'chat_cubit.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class GetChatListIsLoading extends ChatState {}

class GetChatListSuccess extends ChatState {
  final List<ChatList> data;

  const GetChatListSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetChatListError extends ChatState {
  final Failure failure;

  const GetChatListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class ChatDataIsLoading extends ChatState {}

class ChatDataSuccess extends ChatState {
  final List<ChatData> data;

  const ChatDataSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class ChatDataError extends ChatState {
  final Failure failure;

  const ChatDataError({required this.failure});

  @override
  List<Object> get props => [failure];
}
