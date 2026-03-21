import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class UpdateSellerDocumentsParams {
  final String token;
  final String loginID;
  final String document;
  final String documentTypeId;
  final String description;

  UpdateSellerDocumentsParams({
    required this.token,
    required this.loginID,
    required this.document,
    required this.documentTypeId,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "LoginID": loginID,
        "Document": document,
        "DocumentTypeID": documentTypeId,
        "Description": description,
        "DeviceID": Constants.deviceID,
      };
}

class UpdateSellerDocumentsUsecase
    implements UseCase<bool, UpdateSellerDocumentsParams> {
  final ChatRepository chatRepository;

  UpdateSellerDocumentsUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, bool>> call(UpdateSellerDocumentsParams params) =>
      chatRepository.updateFmcgSellerDocuments(params);
}
