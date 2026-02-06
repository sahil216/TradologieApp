import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../repositories/authentication_repository.dart';

class SignOutUsecase implements UseCase<bool, NoParams> {
  final AuthenticationRepository authenticationRepository;

  SignOutUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, bool>> call(NoParams params) =>
      authenticationRepository.signOut(params);
}
