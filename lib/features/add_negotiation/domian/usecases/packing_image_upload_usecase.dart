import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class PackingImageUploadUsecase implements UseCase<bool, File?> {
  final AddNegotiationRepository addNegotiationRepository;

  PackingImageUploadUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, bool>> call(File? params) =>
      addNegotiationRepository.packingImageUpload(params);
}
