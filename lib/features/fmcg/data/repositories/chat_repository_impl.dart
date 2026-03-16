import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/data/datasources/chat_remote_data_source.dart';
import 'package:tradologie_app/features/fmcg/data/models/chat_data_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/chat_list_model.dart';
import 'package:tradologie_app/features/fmcg/data/models/distributor_enquiry_list_model.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_list_usecase.dart';

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
      NoParams params) async {
    try {
      final response =
          await chatRemoteDataSource.getDistributorList(NoParams());
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
}
