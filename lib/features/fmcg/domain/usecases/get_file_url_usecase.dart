import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_file_url_response.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class GetFileUrlParams {
  final String token;
  final String deviceId;
  final File? file;
  final String type;

  GetFileUrlParams({
    required this.token,
    required this.deviceId,
    required this.file,
    required this.type,
  });

  Future<Map<String, dynamic>> toJson() async {
    return {
      if (file != null)
        "File": await MultipartFile.fromFile(
          file?.path ?? "",
          filename: file?.path.split('/').last ?? "",
        )
      else
        "File": "",
    };
  }
}

class GetFileUrlUsecase
    implements UseCase<GetFileUrlResponse, GetFileUrlParams> {
  final ChatRepository chatRepository;

  GetFileUrlUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, GetFileUrlResponse>> call(GetFileUrlParams params) =>
      chatRepository.getFileUrl(params);
}
