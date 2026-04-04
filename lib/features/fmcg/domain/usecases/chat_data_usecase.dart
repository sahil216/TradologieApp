import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class ChatDataParams {
  final String contents;
  final String buyerID;
  final String chatID;
  final String sellerID;
  final String token;
  final String deviceID;
  final bool isMessage;
  final String? fileType;
  final String? attachmentType;
  final String? type;

  ChatDataParams(
      {required this.contents,
      required this.buyerID,
      required this.chatID,
      required this.sellerID,
      required this.token,
      required this.deviceID,
      required this.isMessage,
      this.fileType,
      this.attachmentType,
      this.type});

  Map<String, dynamic> toJson() => {
        "BuyerID": buyerID,
        "ChatID": chatID,
        "SellerID": sellerID,
        "Contents": contents,
        "Token": token,
        "DeviceID": deviceID,
        "IsMessage": isMessage,
        "FileType": fileType,
        "AttachmentType": attachmentType,
        "Type": type,
      };
}

class ChatDataUsecase implements UseCase<List<ChatData>, ChatDataParams> {
  final ChatRepository chatRepository;

  ChatDataUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, List<ChatData>>> call(ChatDataParams params) =>
      chatRepository.chatData(params);
}
