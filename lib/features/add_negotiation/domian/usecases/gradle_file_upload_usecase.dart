import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class GradleFileUploadUsecase implements UseCase<bool, NoParams> {
  final AddNegotiationRepository addNegotiationRepository;

  GradleFileUploadUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      addNegotiationRepository.gradleFileUpload(params);
}
