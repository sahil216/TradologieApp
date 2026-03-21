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

class DistributorListIsLoading extends ChatState {}

class DistributorListSuccess extends ChatState {
  final List<DistributorEnquiryList> data;

  const DistributorListSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class DistributorListError extends ChatState {
  final Failure failure;

  const DistributorListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class UpdateSellerDocumentsIsLoading extends ChatState {}

class UpdateSellerDocumentsSuccess extends ChatState {
  final bool data;

  const UpdateSellerDocumentsSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class UpdateSellerDocumentsError extends ChatState {
  final Failure failure;

  const UpdateSellerDocumentsError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class UpdateSellerProfileIsLoading extends ChatState {}

class UpdateSellerProfileSuccess extends ChatState {
  final bool data;

  const UpdateSellerProfileSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class UpdateSellerProfileError extends ChatState {
  final Failure failure;

  const UpdateSellerProfileError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GetSellerProfileIsLoading extends ChatState {}

class GetSellerProfileSuccess extends ChatState {
  final FmcgGetSellerProfile data;

  const GetSellerProfileSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetSellerProfileError extends ChatState {
  final Failure failure;

  const GetSellerProfileError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GetSellerDocumentsIsLoading extends ChatState {}

class GetSellerDocumentsSuccess extends ChatState {
  final FmcgSellerDocumentDetail data;

  const GetSellerDocumentsSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetSellerDocumentsError extends ChatState {
  final Failure failure;

  const GetSellerDocumentsError({required this.failure});

  @override
  List<Object> get props => [failure];
}
