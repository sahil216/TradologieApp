import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_login_success.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_seller_signin_usecase.dart';

class FmcgBuyerLoginUsecase
    implements UseCase<FmcgBuyerLoginSuccess, FmcgSellerSigninParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgBuyerLoginUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, FmcgBuyerLoginSuccess>> call(
          FmcgSellerSigninParams params) =>
      authenticationRepository.fmcgBuyerSignin(params);
}
