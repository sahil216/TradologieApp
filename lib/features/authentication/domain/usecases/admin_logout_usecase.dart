import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';

import '../../../../core/error/failures.dart';
import '../repositories/authentication_repository.dart';

class AdminLogoutUsecase implements UseCase<String, NoParams> {
  final AuthenticationRepository authenticationRepository;

  AdminLogoutUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, String>> call(NoParams params) =>
      authenticationRepository.adminLogout(params);
}
