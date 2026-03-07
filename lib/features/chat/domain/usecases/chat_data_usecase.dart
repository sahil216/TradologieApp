import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/chat/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/chat/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/chat/domain/repositories/chat_repositories.dart';

class ChatDataParams {
  final String contents;
  final String buyerID;
  final String sellerID;
  final String token;
  ChatDataParams(
      {required this.contents,
      required this.buyerID,
      required this.sellerID,
      required this.token});

  Map<String, dynamic> toJson() => {
        "BuyerID": buyerID,
        "SellerID": sellerID,
        "Contents": contents,
        "Token": token
      };
}

class ChatDataUsecase implements UseCase<List<ChatData>, ChatDataParams> {
  final ChatRepository chatRepository;

  ChatDataUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, List<ChatData>>> call(ChatDataParams params) =>
      chatRepository.chatData(params);
}
