import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/buyer_login_success.dart';
import '../repositories/authentication_repository.dart';
import 'supplier_social_login_usecase.dart';

class BuyerSocialLoginUsecase
    implements UseCase<BuyerLoginSuccess?, SupplierSocialLoginParams> {
  final AuthenticationRepository authenticationRepository;

  BuyerSocialLoginUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, BuyerLoginSuccess?>> call(
          SupplierSocialLoginParams params) =>
      authenticationRepository.buyerLoginWithSocialMedia(params);
}
