import 'package:tradologie_app/core/api/api_consumer.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/response_wrapper/response_wrapper.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_buyer_brand_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_distributor_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_quotation_cart_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_buyer_quotation_usecase.dart';
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

abstract class ChatRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> getChatList(ChatListParams params);

  Future<ResponseWrapper<dynamic>?> chatData(ChatDataParams params);

  Future<ResponseWrapper<dynamic>?> getDistributorList(
      GetDistributorListParams params);

  Future<ResponseWrapper<dynamic>?> getProductsList(
      GetProductsListParams params);

  Future<ResponseWrapper<dynamic>?> getProductsListForSeller(
      GetProductsListParams params);

  Future<ResponseWrapper<dynamic>?> fmcgGetSellerProfile(
      GetSellerProfileParams params);

  Future<ResponseWrapper<dynamic>?> fmcgUpdateSellerProfile(
      UpdateSellerProfileParams params);

  Future<ResponseWrapper<dynamic>?> fmcgGetSellerDocuments(
      GetSellerDocumentsParams params);

  Future<ResponseWrapper<dynamic>?> fmcgUpdateSellerDocuments(
      UpdateSellerDocumentsParams params);

  Future<ResponseWrapper<dynamic>?> getBuyerBrandsList(
      GetBuyerBrandsListParams params);

  Future<ResponseWrapper<dynamic>?> addBuyerBrandInterest(
      AddBuyerBrandInterestParams params);

  Future<ResponseWrapper<dynamic>?> addDistributorInterest(
      AddDistributorInterestParams params);

  Future<ResponseWrapper<dynamic>?> getFileUrl(GetFileUrlParams params);

  Future<ResponseWrapper<dynamic>?> getInitialChatId(
      GetInitialChatIdParams params);

  Future<ResponseWrapper<dynamic>?> getChatbotQueryList(
      ChatbotQueryListParams params);

  Future<ResponseWrapper<dynamic>?> getChatbotTranList(
      ChatbotTranListParams params);

  Future<ResponseWrapper<dynamic>?> getFmcgQuotationList(
      ChatbotQueryListParams params);

  Future<ResponseWrapper<dynamic>?> getFmcgQuotationTranList(
      QuotationTranListParams params);

  Future<ResponseWrapper<dynamic>?> addQuotationCart(AddQuotationCartParams params);

  Future<ResponseWrapper<dynamic>?> deleteQuotationCart(
      DeleteQuotationCartParams params);

  Future<ResponseWrapper<dynamic>?> addBuyerQuotation(
      AddBuyerQuotationParams params);

  Future<ResponseWrapper<dynamic>?> getBuyerQuotationList(
      GetBuyerQuotationListParams params);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  ApiConsumer apiConsumer;

  ChatRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ResponseWrapper<dynamic>?> getChatList(ChatListParams params) async {
    return await apiConsumer.post(
      EndPoints.getChatList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> chatData(ChatDataParams params) async {
    return await apiConsumer.post(
      EndPoints.chatData,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getDistributorList(
      GetDistributorListParams params) async {
    return await apiConsumer.post(
      EndPoints.getDistributorList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgGetSellerProfile(
      GetSellerProfileParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgGetSellerProfile,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgUpdateSellerProfile(
      UpdateSellerProfileParams params) async {
    return await apiConsumer.post(EndPoints.fmcgUpdateSellerProfile,
        body: await params.toJson(), formDataIsEnabled: true);
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgGetSellerDocuments(
      GetSellerDocumentsParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgGetSellerDocuments,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgUpdateSellerDocuments(
      UpdateSellerDocumentsParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgUpdateSellerDocuments,
      body: await params.toJson(),
      formDataIsEnabled: true,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getBuyerBrandsList(
      GetBuyerBrandsListParams params) async {
    return await apiConsumer.post(
      EndPoints.getBuyerBrandsList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> addDistributorInterest(
      AddDistributorInterestParams params) async {
    return await apiConsumer.post(
      EndPoints.addDistributorInterest,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> addBuyerBrandInterest(
      AddBuyerBrandInterestParams params) async {
    return await apiConsumer.post(
      EndPoints.addBrandInterest,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getFileUrl(GetFileUrlParams params) async {
    return await apiConsumer.post(
        "${EndPoints.getFileUrl}?Token=${params.token}&DeviceID=${params.deviceId}&Type=${params.type}",
        body: await params.toJson(),
        formDataIsEnabled: true);
  }

  @override
  Future<ResponseWrapper<dynamic>?> getInitialChatId(
      GetInitialChatIdParams params) async {
    return await apiConsumer.post(
      EndPoints.getInitialChatId,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getProductsList(
      GetProductsListParams params) async {
    return await apiConsumer.post(
      EndPoints.getProductsList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getProductsListForSeller(
      GetProductsListParams params) async {
    return await apiConsumer.post(
      EndPoints.getProductsListForSeller,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getChatbotQueryList(
      ChatbotQueryListParams params) async {
    return await apiConsumer.post(
      EndPoints.chatbotQueryList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getChatbotTranList(
      ChatbotTranListParams params) async {
    return await apiConsumer.post(
      EndPoints.chatbotTranList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getFmcgQuotationList(
      ChatbotQueryListParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgQuotationList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getFmcgQuotationTranList(
      QuotationTranListParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgQuotationTranList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> addQuotationCart(
      AddQuotationCartParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgAddQuotationCart,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> deleteQuotationCart(
      DeleteQuotationCartParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgDeleteQuotationCart,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> addBuyerQuotation(
      AddBuyerQuotationParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgAddBuyerQuotation,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getBuyerQuotationList(
      GetBuyerQuotationListParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgBuyerQuotationCartList,
      body: params.toJson(),
    );
  }
}
