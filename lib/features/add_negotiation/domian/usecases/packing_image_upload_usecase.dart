import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class PackingImageUploadUsecase implements UseCase<bool, NoParams> {
  final AddNegotiationRepository addNegotiationRepository;

  PackingImageUploadUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      addNegotiationRepository.packingImageUpload(params);
}
