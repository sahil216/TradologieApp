import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_detail.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class GetSellerDocumentsParams {
  final String token;
  final String loginID;
  final String deviceID;

  GetSellerDocumentsParams(
      {required this.token, required this.loginID, required this.deviceID});

  Map<String, dynamic> toJson() =>
      {"Token": token, "LoginID": loginID, "DeviceID": deviceID};
}

class GetSellerDocumentsUsecase
    implements UseCase<FmcgSellerDocumentDetail, GetSellerDocumentsParams> {
  final ChatRepository chatRepository;

  GetSellerDocumentsUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, FmcgSellerDocumentDetail>> call(
          GetSellerDocumentsParams params) =>
      chatRepository.getFmcgSellerDocuments(params);
}
