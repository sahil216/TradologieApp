import 'package:tradologie_app/core/api/api_consumer.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/response_wrapper/response_wrapper.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_profile_usecase.dart';

abstract class ChatRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> getChatList(ChatListParams params);
  Future<ResponseWrapper<dynamic>?> chatData(ChatDataParams params);
  Future<ResponseWrapper<dynamic>?> getDistributorList(NoParams params);
  Future<ResponseWrapper<dynamic>?> fmcgGetSellerProfile(
      GetSellerProfileParams params);
  Future<ResponseWrapper<dynamic>?> fmcgUpdateSellerProfile(
      UpdateSellerProfileParams params);
  Future<ResponseWrapper<dynamic>?> fmcgGetSellerDocuments(
      GetSellerDocumentsParams params);
  Future<ResponseWrapper<dynamic>?> fmcgUpdateSellerDocuments(
      UpdateSellerDocumentsParams params);
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
  Future<ResponseWrapper<dynamic>?> getDistributorList(NoParams params) async {
    return await apiConsumer.post(
      EndPoints.getDistributorList,
      body: {"Token": Constants.token},
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
}
