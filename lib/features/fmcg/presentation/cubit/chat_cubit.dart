import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_query_list_item.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_tran_message.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_buyer_brands_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_get_seller_profile.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_detail.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/buyer_quotation_item.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_file_url_response.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_initial_chat_id.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_products_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_list_item.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_tran_item.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_buyer_brand_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_distributor_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_quotation_cart_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_buyer_quotation_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_buyer_brands_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_distributor_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_query_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_file_url_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_initial_chat_id_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_fmcg_quotation_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_fmcg_quotation_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_products_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_products_list_for_seller_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_profile_usecase.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatListUsecase chatListUsecase;
  final ChatDataUsecase chatDataUsecase;
  final GetDistributorListUsecase getDistributorListUsecase;
  final GetSellerDocumentsUsecase getSellerDocumentsUsecase;
  final GetSellerProfileUsecase getSellerProfileUsecase;
  final UpdateSellerProfileUsecase updateSellerProfileUsecase;
  final UpdateSellerDocumentsUsecase updateSellerDocumentsUsecase;
  final GetBuyerBrandsListUsecase getBuyerBrandsListUsecase;
  final AddDistributorInterestUsecase addDistributorInterestUsecase;
  final AddBuyerBrandInterestUsecase addBuyerBrandInterestUsecase;
  final GetFileUrlUsecase getFileUrlUsecase;
  final GetInitialChatIdUsecase getInitialChatIdUsecase;
  final GetProductsListUsecase getProductsListUsecase;
  final GetChatbotQueryListUsecase getChatbotQueryListUsecase;
  final GetChatbotTranListUsecase getChatbotTranListUsecase;
  final GetFmcgQuotationListUsecase getFmcgQuotationListUsecase;
  final GetFmcgQuotationTranListUsecase getFmcgQuotationTranListUsecase;
  final GetProductsListForSellerUsecase getProductsListForSellerUsecase;
  final AddQuotationCartUsecase addQuotationCartUsecase;
  final GetBuyerQuotationListUsecase getBuyerQuotationListUsecase;

  ChatCubit(
      {required this.chatListUsecase,
      required this.chatDataUsecase,
      required this.getDistributorListUsecase,
      required this.getSellerDocumentsUsecase,
      required this.getSellerProfileUsecase,
      required this.updateSellerProfileUsecase,
      required this.updateSellerDocumentsUsecase,
      required this.getBuyerBrandsListUsecase,
      required this.addDistributorInterestUsecase,
      required this.addBuyerBrandInterestUsecase,
      required this.getFileUrlUsecase,
      required this.getInitialChatIdUsecase,
      required this.getProductsListUsecase,
      required this.getChatbotQueryListUsecase,
      required this.getChatbotTranListUsecase,
      required this.getFmcgQuotationListUsecase,
      required this.getFmcgQuotationTranListUsecase,
      required this.getProductsListForSellerUsecase,
      required this.addQuotationCartUsecase,
      required this.getBuyerQuotationListUsecase})
      : super(ChatInitial());

  Future<void> getChatList(ChatListParams params) async {
    emit(GetChatListIsLoading());
    Either<Failure, List<ChatList>> response = await chatListUsecase(params);
    emit(response.fold(
      (failure) => GetChatListError(failure: failure),
      (res) => GetChatListSuccess(data: res),
    ));
  }

  Future<void> chatData(ChatDataParams params) async {
    emit(ChatDataIsLoading());
    Either<Failure, List<ChatData>> response = await chatDataUsecase(params);
    emit(response.fold(
      (failure) => ChatDataError(failure: failure),
      (res) => ChatDataSuccess(data: res),
    ));
  }

  Future<void> getDistributorList(GetDistributorListParams params) async {
    emit(DistributorListIsLoading());
    Either<Failure, List<DistributorEnquiryList>> response =
        await getDistributorListUsecase(params);
    emit(response.fold(
      (failure) => DistributorListError(failure: failure),
      (res) => DistributorListSuccess(data: res),
    ));
  }

  Future<void> getProductsList(GetProductsListParams params) async {
    emit(ProductsListIsLoading());
    Either<Failure, List<GetProductsList>> response =
        await getProductsListUsecase(params);
    emit(response.fold(
      (failure) => ProductsListError(failure: failure),
      (res) => ProductsListSuccess(data: res),
    ));
  }

  Future<void> getProductsListForSeller(GetProductsListParams params) async {
    emit(ProductsListForSellerIsLoading());
    Either<Failure, List<GetProductsList>> response =
        await getProductsListForSellerUsecase(params);
    emit(response.fold(
      (failure) => ProductsListForSellerError(failure: failure),
      (res) => ProductsListForSellerSuccess(data: res),
    ));
  }

  Future<void> updateSellerDocuments(UpdateSellerDocumentsParams params) async {
    emit(UpdateSellerDocumentsIsLoading());
    Either<Failure, bool> response = await updateSellerDocumentsUsecase(params);
    emit(response.fold(
      (failure) => UpdateSellerDocumentsError(failure: failure),
      (res) => UpdateSellerDocumentsSuccess(data: res),
    ));
  }

  Future<void> updateSellerProfile(UpdateSellerProfileParams params) async {
    emit(UpdateSellerProfileIsLoading());
    Either<Failure, bool> response = await updateSellerProfileUsecase(params);
    emit(response.fold(
      (failure) => UpdateSellerProfileError(failure: failure),
      (res) => UpdateSellerProfileSuccess(data: res),
    ));
  }

  Future<void> getSellerDocuments(GetSellerDocumentsParams params) async {
    emit(GetSellerDocumentsIsLoading());
    Either<Failure, FmcgSellerDocumentDetail> response =
        await getSellerDocumentsUsecase(params);
    emit(response.fold(
      (failure) => GetSellerDocumentsError(failure: failure),
      (res) => GetSellerDocumentsSuccess(data: res),
    ));
  }

  Future<void> getSellerProfile(GetSellerProfileParams params) async {
    emit(GetSellerProfileIsLoading());
    Either<Failure, FmcgGetSellerProfile> response =
        await getSellerProfileUsecase(params);
    emit(response.fold(
      (failure) => GetSellerProfileError(failure: failure),
      (res) => GetSellerProfileSuccess(data: res),
    ));
  }

  Future<void> getBuyerBrandsList(GetBuyerBrandsListParams params) async {
    emit(GetBuyerBrandsListIsLoading());
    Either<Failure, List<FmcgBuyerBrandsList>> response =
        await getBuyerBrandsListUsecase(params);
    emit(response.fold(
      (failure) => GetBuyerBrandsListError(failure: failure),
      (res) => GetBuyerBrandsListSuccess(data: res),
    ));
  }

  Future<void> addBuyerBrandInterest(AddBuyerBrandInterestParams params) async {
    emit(AddBuyerBrandInterestIsLoading());
    Either<Failure, bool> response = await addBuyerBrandInterestUsecase(params);
    emit(response.fold(
      (failure) => AddBuyerBrandInterestError(failure: failure),
      (res) => AddBuyerBrandInterestSuccess(data: res),
    ));
  }

  Future<void> addDistributorInterest(
      AddDistributorInterestParams params) async {
    emit(AddDistributorInterestIsLoading());
    Either<Failure, bool> response =
        await addDistributorInterestUsecase(params);
    emit(response.fold(
      (failure) => AddDistributorInterestError(failure: failure),
      (res) => AddDistributorInterestSuccess(data: res),
    ));
  }

  Future<void> getFileUrl(GetFileUrlParams params) async {
    emit(GetFileUrlIsLoading());
    Either<Failure, GetFileUrlResponse> response =
        await getFileUrlUsecase(params);
    emit(response.fold(
      (failure) => GetFileUrlError(failure: failure),
      (res) => GetFileUrlSuccess(data: res),
    ));
  }

  Future<void> getInitialChatId(GetInitialChatIdParams params) async {
    emit(GetInitialChatIdIsLoading());
    Either<Failure, GetInitialChatId> response =
        await getInitialChatIdUsecase(params);
    emit(response.fold(
      (failure) => GetInitialChatIdError(failure: failure),
      (res) => GetInitialChatIdSuccess(data: res),
    ));
  }

  Future<void> getChatbotQueryList(ChatbotQueryListParams params) async {
    emit(ChatbotQueryListLoading());
    final Either<Failure, ChatbotQueryListResult> response =
        await getChatbotQueryListUsecase(params);
    emit(response.fold(
      (failure) => ChatbotQueryListError(failure: failure),
      (res) => ChatbotQueryListSuccess(
        items: res.items,
        totalPages: res.totalPages,
        totalRecords: res.totalRecords,
      ),
    ));
  }

  Future<void> getChatbotTranList(ChatbotTranListParams params) async {
    emit(ChatbotTranListLoading());
    final Either<Failure, List<ChatbotTranMessage>> response =
        await getChatbotTranListUsecase(params);
    emit(response.fold(
      (failure) => ChatbotTranListError(failure: failure),
      (list) => ChatbotTranListSuccess(messages: list),
    ));
  }

  Future<void> getFmcgQuotationList(ChatbotQueryListParams params) async {
    emit(FmcgQuotationListLoading());
    final Either<Failure, FmcgQuotationListResult> response =
        await getFmcgQuotationListUsecase(params);
    emit(response.fold(
      (failure) => FmcgQuotationListError(failure: failure),
      (res) => FmcgQuotationListSuccess(
        items: res.items,
        totalPages: res.totalPages,
        totalRecords: res.totalRecords,
      ),
    ));
  }

  Future<void> getFmcgQuotationTranList(QuotationTranListParams params) async {
    emit(FmcgQuotationTranListLoading());
    final Either<Failure, List<FmcgQuotationTranItem>> response =
        await getFmcgQuotationTranListUsecase(params);
    emit(response.fold(
      (failure) => FmcgQuotationTranListError(failure: failure),
      (list) => FmcgQuotationTranListSuccess(items: list),
    ));
  }

  Future<void> addQuotationCart(AddQuotationCartParams params) async {
    emit(AddQuotationCartIsLoading(productId: params.productId));
    final Either<Failure, String> response = await addQuotationCartUsecase(params);
    emit(response.fold(
      (failure) => AddQuotationCartError(failure: failure),
      (message) => AddQuotationCartSuccess(
        productId: params.productId,
        message: message,
      ),
    ));
  }

  Future<void> getBuyerQuotationList(GetBuyerQuotationListParams params) async {
    emit(BuyerQuotationListLoading());
    final Either<Failure, List<BuyerQuotationItem>> response =
        await getBuyerQuotationListUsecase(params);
    emit(response.fold(
      (failure) => BuyerQuotationListError(failure: failure),
      (items) => BuyerQuotationListSuccess(items: items),
    ));
  }
}
