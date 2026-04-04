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

class GetBuyerBrandsListIsLoading extends ChatState {}

class GetBuyerBrandsListSuccess extends ChatState {
  final List<FmcgBuyerBrandsList> data;

  const GetBuyerBrandsListSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetBuyerBrandsListError extends ChatState {
  final Failure failure;

  const GetBuyerBrandsListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AddBuyerBrandInterestIsLoading extends ChatState {}

class AddBuyerBrandInterestSuccess extends ChatState {
  final bool data;

  const AddBuyerBrandInterestSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class AddBuyerBrandInterestError extends ChatState {
  final Failure failure;

  const AddBuyerBrandInterestError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AddDistributorInterestIsLoading extends ChatState {}

class AddDistributorInterestSuccess extends ChatState {
  final bool data;

  const AddDistributorInterestSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class AddDistributorInterestError extends ChatState {
  final Failure failure;

  const AddDistributorInterestError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GetFileUrlIsLoading extends ChatState {}

class GetFileUrlSuccess extends ChatState {
  final GetFileUrlResponse data;

  const GetFileUrlSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetFileUrlError extends ChatState {
  final Failure failure;

  const GetFileUrlError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GetInitialChatIdIsLoading extends ChatState {}

class GetInitialChatIdSuccess extends ChatState {
  final GetInitialChatId data;

  const GetInitialChatIdSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class GetInitialChatIdError extends ChatState {
  final Failure failure;

  const GetInitialChatIdError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class ProductsListIsLoading extends ChatState {}

class ProductsListSuccess extends ChatState {
  final List<GetProductsList> data;

  const ProductsListSuccess({
    required this.data,
  });

  @override
  List<Object> get props => [data];
}

class ProductsListError extends ChatState {
  final Failure failure;

  const ProductsListError({required this.failure});

  @override
  List<Object> get props => [failure];
}
