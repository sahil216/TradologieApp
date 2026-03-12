import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/chat/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/chat/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/chat/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/chat/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/chat/domain/usecases/chat_list_usecase.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ChatList>>> getChatList(ChatListParams params);
  Future<Either<Failure, List<ChatData>>> chatData(ChatDataParams params);
  Future<Either<Failure, List<DistributorEnquiryList>>> getDistributorList(
      NoParams params);
}
