import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class ChatListParams {
  final String sellerID;
  final String token;
  final String deviceID;

  ChatListParams({
    required this.sellerID,
    required this.token,
    required this.deviceID,
  });

  Map<String, dynamic> toJson() =>
      {"SellerID": sellerID, "Token": token, "DeviceID": deviceID};
}

class ChatListUsecase implements UseCase<List<ChatList>, ChatListParams> {
  final ChatRepository chatRepository;

  ChatListUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, List<ChatList>>> call(ChatListParams params) =>
      chatRepository.getChatList(params);
}
