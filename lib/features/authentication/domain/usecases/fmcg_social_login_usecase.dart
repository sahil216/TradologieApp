import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/fmcg_buyer_login_success.dart';
import '../entities/fmcg_seller_signin_response.dart';
import '../repositories/authentication_repository.dart';
import 'supplier_social_login_usecase.dart';

class FmcgBuyerSocialLoginUsecase
    implements UseCase<FmcgBuyerLoginSuccess, SupplierSocialLoginParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgBuyerSocialLoginUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, FmcgBuyerLoginSuccess>> call(
          SupplierSocialLoginParams params) =>
      authenticationRepository.fmcgBuyerLoginWithSocialMedia(params);
}

class FmcgSellerSocialLoginUsecase
    implements UseCase<FmcgSellerSigninResponse, SupplierSocialLoginParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgSellerSocialLoginUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, FmcgSellerSigninResponse>> call(
          SupplierSocialLoginParams params) =>
      authenticationRepository.fmcgSellerLoginWithSocialMedia(params);
}
