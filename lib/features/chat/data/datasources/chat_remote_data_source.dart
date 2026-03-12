import 'package:tradologie_app/core/api/api_consumer.dart';
import 'package:tradologie_app/core/api/end_points.dart';
import 'package:tradologie_app/core/response_wrapper/response_wrapper.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/chat/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/chat/domain/usecases/chat_list_usecase.dart';

abstract class ChatRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> getChatList(ChatListParams params);
  Future<ResponseWrapper<dynamic>?> chatData(ChatDataParams params);
  Future<ResponseWrapper<dynamic>?> getDistributorList(NoParams params);
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
}
