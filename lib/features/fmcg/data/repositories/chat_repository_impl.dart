import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/features/fmcg/data/datasources/chat_remote_data_source.dart';
import 'package:tradologie_app/features/fmcg/data/models/chat_data_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/chat_list_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/distributor_enquiry_list_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/fmcg_buyer_brands_list_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/fmcg_get_seller_profile_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/fmcg_seller_document_detail_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/get_file_url_response_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/get_initial_chat_id_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/chatbot_query_list_item_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/chatbot_tran_message_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/buyer_quotation_item_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/fmcg_quotation_list_item_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/fmcg_quotation_tran_item_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/get_products_list_model.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_query_list_item.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_tran_message.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/buyer_quotation_item.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_buyer_brands_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_get_seller_profile.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_detail.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_file_url_response.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_initial_chat_id.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_products_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_list_item.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_tran_item.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';
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
import 'package:tradologie_app/features/fmcg/domain/usecases/get_fmcg_quotation_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_file_url_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_initial_chat_id_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_products_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_profile_usecase.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;

  ChatRepositoryImpl({
    required this.chatRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<ChatList>>> getChatList(
      ChatListParams params) async {
    try {
      final response = await chatRemoteDataSource.getChatList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => ChatListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<ChatData>>> chatData(
      ChatDataParams params) async {
    try {
      final response = await chatRemoteDataSource.chatData(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => ChatDataModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<DistributorEnquiryList>>> getDistributorList(
      GetDistributorListParams params) async {
    try {
      final response = await chatRemoteDataSource.getDistributorList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => DistributorEnquiryListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, FmcgGetSellerProfile>> getFmcgSellerProfile(
      GetSellerProfileParams params) async {
    try {
      final response = await chatRemoteDataSource.fmcgGetSellerProfile(params);
      if (response != null && response.success) {
        SecureStorageService secureStorage = SecureStorageService();
        var data = FmcgGetSellerProfileModel.fromJson(response.data);
        await secureStorage.write(
            AppStrings.analyticsUrl, data.analyticsUrl ?? "");
        Constants.analyticsUrl = data.analyticsUrl ?? "";
        return Right(data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> updateFmcgSellerProfile(
      UpdateSellerProfileParams params) async {
    try {
      final response =
          await chatRemoteDataSource.fmcgUpdateSellerProfile(params);
      if (response != null && response.success) {
        return Right(response.data);
      }

      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, FmcgSellerDocumentDetail>> getFmcgSellerDocuments(
      GetSellerDocumentsParams params) async {
    try {
      final response =
          await chatRemoteDataSource.fmcgGetSellerDocuments(params);
      if (response != null && response.success) {
        return Right(FmcgSellerDocumentDetailModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> updateFmcgSellerDocuments(
      UpdateSellerDocumentsParams params) async {
    try {
      final response =
          await chatRemoteDataSource.fmcgUpdateSellerDocuments(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgBuyerBrandsList>>> getBuyerBrandsList(
      GetBuyerBrandsListParams params) async {
    try {
      final response = await chatRemoteDataSource.getBuyerBrandsList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgBuyerBrandsListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> addBuyerBrandInterest(
      AddBuyerBrandInterestParams params) async {
    try {
      final response = await chatRemoteDataSource.addBuyerBrandInterest(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> addDistributorInterest(
      AddDistributorInterestParams params) async {
    try {
      final response =
          await chatRemoteDataSource.addDistributorInterest(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, GetFileUrlResponse>> getFileUrl(
      GetFileUrlParams params) async {
    try {
      final response = await chatRemoteDataSource.getFileUrl(params);
      if (response != null && response.success) {
        return Right(GetFileUrlResponseModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, GetInitialChatId>> getInitialChatId(
      GetInitialChatIdParams params) async {
    try {
      final response = await chatRemoteDataSource.getInitialChatId(params);
      if (response != null && response.success) {
        return Right(GetInitialChatIdModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<GetProductsList>>> getProductsList(
      GetProductsListParams params) async {
    try {
      final response = await chatRemoteDataSource.getProductsList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => GetProductsListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<GetProductsList>>> getProductsListForSeller(
      GetProductsListParams params) async {
    try {
      final response =
          await chatRemoteDataSource.getProductsListForSeller(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => GetProductsListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, ChatbotQueryListResult>> getChatbotQueryList(
      ChatbotQueryListParams params) async {
    try {
      final response = await chatRemoteDataSource.getChatbotQueryList(params);
      if (response != null && response.success) {
        final map = response.data as Map<String, dynamic>;
        final detail = map['detail'] as List<dynamic>? ?? [];
        final items = detail
            .map((e) =>
                ChatbotQueryListItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
        final totalPages = _parseInt(map['totalPages'], fallback: 1);
        final totalRecords = _parseInt(map['totalRecords'],
            fallback: items.length);
        return Right(ChatbotQueryListResult(
          items: items,
          totalPages: totalPages < 1 ? 1 : totalPages,
          totalRecords: totalRecords,
        ));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  int _parseInt(dynamic v, {required int fallback}) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? fallback;
    return fallback;
  }

  @override
  Future<Either<Failure, FmcgQuotationListResult>> getFmcgQuotationList(
      ChatbotQueryListParams params) async {
    try {
      final response =
          await chatRemoteDataSource.getFmcgQuotationList(params);
      if (response != null && response.success) {
        final map = response.data as Map<String, dynamic>;
        final detail = map['detail'] as List<dynamic>? ?? [];
        final items = detail
            .map((e) => FmcgQuotationListItemModel.fromJson(
                e as Map<String, dynamic>))
            .toList();
        final totalPages = _parseInt(map['totalPages'], fallback: 1);
        final totalRecords = _parseInt(map['totalRecords'],
            fallback: items.length);
        return Right(FmcgQuotationListResult(
          items: items,
          totalPages: totalPages < 1 ? 1 : totalPages,
          totalRecords: totalRecords,
        ));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<ChatbotTranMessage>>> getChatbotTranList(
      ChatbotTranListParams params) async {
    try {
      final response = await chatRemoteDataSource.getChatbotTranList(params);
      if (response != null && response.success) {
        final list = response.data as List<dynamic>? ?? [];
        return Right(
          list
              .map((e) => ChatbotTranMessageModel.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgQuotationTranItem>>> getFmcgQuotationTranList(
      QuotationTranListParams params) async {
    try {
      final response =
          await chatRemoteDataSource.getFmcgQuotationTranList(params);
      if (response != null && response.success) {
        final data = response.data;
        List<dynamic> detail;
        if (data is Map<String, dynamic>) {
          detail = data['detail'] as List<dynamic>? ?? [];
        } else if (data is List<dynamic>) {
          detail = data;
        } else {
          detail = [];
        }
        return Right(
          detail
              .map((e) => FmcgQuotationTranItemModel.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, String>> addQuotationCart(
      AddQuotationCartParams params) async {
    try {
      final response = await chatRemoteDataSource.addQuotationCart(params);
      if (response != null && response.success) {
        return Right(response.message);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, String>> deleteQuotationCart(
      DeleteQuotationCartParams params) async {
    try {
      final response = await chatRemoteDataSource.deleteQuotationCart(params);
      if (response != null && response.success) {
        return Right(response.message);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, int>> addBuyerQuotation(
      AddBuyerQuotationParams params) async {
    try {
      final response = await chatRemoteDataSource.addBuyerQuotation(params);
      if (response != null && response.success) {
        final detail = response.data;
        if (detail is int) return Right(detail);
        return Right(int.tryParse(detail?.toString() ?? '') ?? 0);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<BuyerQuotationItem>>> getBuyerQuotationList(
      GetBuyerQuotationListParams params) async {
    try {
      final response = await chatRemoteDataSource.getBuyerQuotationList(params);
      if (response != null && response.success) {
        return Right(
          (response.data as List<dynamic>? ?? [])
              .map((e) => BuyerQuotationItemModel.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
        );
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
