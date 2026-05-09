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

class ProductsListForSellerIsLoading extends ChatState {}

class ProductsListForSellerSuccess extends ChatState {
  final List<GetProductsList> data;

  const ProductsListForSellerSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class ProductsListForSellerError extends ChatState {
  final Failure failure;

  const ProductsListForSellerError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class ChatbotQueryListLoading extends ChatState {}

class ChatbotQueryListSuccess extends ChatState {
  final List<ChatbotQueryListItem> items;
  final int totalPages;
  final int totalRecords;

  const ChatbotQueryListSuccess({
    required this.items,
    required this.totalPages,
    required this.totalRecords,
  });

  @override
  List<Object> get props => [items, totalPages, totalRecords];
}

class ChatbotQueryListError extends ChatState {
  final Failure failure;

  const ChatbotQueryListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class ChatbotTranListLoading extends ChatState {}

class ChatbotTranListSuccess extends ChatState {
  final List<ChatbotTranMessage> messages;

  const ChatbotTranListSuccess({required this.messages});

  @override
  List<Object> get props => [messages];
}

class ChatbotTranListError extends ChatState {
  final Failure failure;

  const ChatbotTranListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class FmcgQuotationListLoading extends ChatState {}

class FmcgQuotationListSuccess extends ChatState {
  final List<FmcgQuotationListItem> items;
  final int totalPages;
  final int totalRecords;

  const FmcgQuotationListSuccess({
    required this.items,
    required this.totalPages,
    required this.totalRecords,
  });

  @override
  List<Object> get props => [items, totalPages, totalRecords];
}

class FmcgQuotationListError extends ChatState {
  final Failure failure;

  const FmcgQuotationListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class FmcgQuotationTranListLoading extends ChatState {}

class FmcgQuotationTranListSuccess extends ChatState {
  final List<FmcgQuotationTranItem> items;

  const FmcgQuotationTranListSuccess({required this.items});

  @override
  List<Object> get props => [items];
}

class FmcgQuotationTranListError extends ChatState {
  final Failure failure;

  const FmcgQuotationTranListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AddQuotationCartIsLoading extends ChatState {
  final int productId;

  const AddQuotationCartIsLoading({required this.productId});

  @override
  List<Object> get props => [productId];
}

class AddQuotationCartSuccess extends ChatState {
  final int productId;
  final String message;

  const AddQuotationCartSuccess({required this.productId, required this.message});

  @override
  List<Object> get props => [productId, message];
}

class AddQuotationCartError extends ChatState {
  final Failure failure;

  const AddQuotationCartError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class BuyerQuotationListLoading extends ChatState {}

class BuyerQuotationListSuccess extends ChatState {
  final List<BuyerQuotationItem> items;

  const BuyerQuotationListSuccess({required this.items});

  @override
  List<Object> get props => [items];
}

class BuyerQuotationListError extends ChatState {
  final Failure failure;

  const BuyerQuotationListError({required this.failure});

  @override
  List<Object> get props => [failure];
}
