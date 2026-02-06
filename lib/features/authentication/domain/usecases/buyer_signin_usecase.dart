import 'package:dartz/dartz.dart';
import 'package:tradologie_app/features/authentication/domain/entities/buyer_login_success.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';
import 'sign_in_usecase.dart';

class BuyerSigninUsecase implements UseCase<BuyerLoginSuccess?, SigninParams> {
  final AuthenticationRepository authenticationRepository;

  BuyerSigninUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, BuyerLoginSuccess?>> call(SigninParams params) =>
      authenticationRepository.buyerSignIn(params);
}
