import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_buyer_brands_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_get_seller_profile.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_detail.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_file_url_response.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_initial_chat_id.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_query_list_item.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_list_item.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_tran_item.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_tran_message.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/buyer_quotation_item.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_products_list.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_buyer_brand_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_distributor_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_buyer_quotation_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_quotation_cart_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/delete_quotation_cart_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_buyer_quotation_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_buyer_brands_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_distributor_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_query_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_fmcg_quotation_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_file_url_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_initial_chat_id_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_products_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_profile_usecase.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatList>>> getChatList(ChatListParams params);

  Future<Either<Failure, List<ChatData>>> chatData(ChatDataParams params);

  Future<Either<Failure, List<DistributorEnquiryList>>> getDistributorList(
      GetDistributorListParams params);

  Future<Either<Failure, FmcgGetSellerProfile>> getFmcgSellerProfile(
      GetSellerProfileParams params);

  Future<Either<Failure, bool>> updateFmcgSellerProfile(
      UpdateSellerProfileParams params);

  Future<Either<Failure, FmcgSellerDocumentDetail>> getFmcgSellerDocuments(
      GetSellerDocumentsParams params);

  Future<Either<Failure, bool>> updateFmcgSellerDocuments(
      UpdateSellerDocumentsParams params);

  Future<Either<Failure, List<FmcgBuyerBrandsList>>> getBuyerBrandsList(
      GetBuyerBrandsListParams params);

  Future<Either<Failure, bool>> addBuyerBrandInterest(
      AddBuyerBrandInterestParams params);

  Future<Either<Failure, bool>> addDistributorInterest(
      AddDistributorInterestParams params);

  Future<Either<Failure, GetFileUrlResponse>> getFileUrl(
      GetFileUrlParams params);

  Future<Either<Failure, GetInitialChatId>> getInitialChatId(
      GetInitialChatIdParams params);

  Future<Either<Failure, List<GetProductsList>>> getProductsList(
      GetProductsListParams params);

  Future<Either<Failure, List<GetProductsList>>> getProductsListForSeller(
      GetProductsListParams params);

  Future<Either<Failure, ChatbotQueryListResult>> getChatbotQueryList(
      ChatbotQueryListParams params);

  Future<Either<Failure, List<ChatbotTranMessage>>> getChatbotTranList(
      ChatbotTranListParams params);

  Future<Either<Failure, FmcgQuotationListResult>> getFmcgQuotationList(
      ChatbotQueryListParams params);

  Future<Either<Failure, List<FmcgQuotationTranItem>>> getFmcgQuotationTranList(
      QuotationTranListParams params);

  Future<Either<Failure, String>> addQuotationCart(AddQuotationCartParams params);

  Future<Either<Failure, String>> deleteQuotationCart(
      DeleteQuotationCartParams params);

  Future<Either<Failure, int>> addBuyerQuotation(AddBuyerQuotationParams params);

  Future<Either<Failure, List<BuyerQuotationItem>>> getBuyerQuotationList(
      GetBuyerQuotationListParams params);
}
