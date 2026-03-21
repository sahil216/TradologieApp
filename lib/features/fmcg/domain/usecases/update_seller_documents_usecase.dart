import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class UpdateSellerDocumentsParams {
  final String token;
  final String loginID;
  final File? document;
  final String documentTypeId;
  final String description;

  UpdateSellerDocumentsParams({
    required this.token,
    required this.loginID,
    required this.document,
    required this.documentTypeId,
    required this.description,
  });

  Future<Map<String, dynamic>> toJson() async => {
        "Token": token,
        "LoginID": loginID,
        "DocumentTypeID": documentTypeId,
        "Description": description,
        "DeviceID": Constants.deviceID,
        if (document != null)
          "Document": await MultipartFile.fromFile(
            document?.path ?? "",
            filename: document?.path.split('/').last ?? "",
          )
        else
          "Document": "",
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
