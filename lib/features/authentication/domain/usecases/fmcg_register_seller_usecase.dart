import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_signin_response.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgRegisterSellerParams {
  final String token;
  final String brandName;
  final String contactName;
  final String countryCode;
  final String emailId;
  final String mobileNo;

  FmcgRegisterSellerParams({
    required this.token,
    required this.brandName,
    required this.contactName,
    required this.countryCode,
    required this.emailId,
    required this.mobileNo,
  });
  Map<String, dynamic> toJson() => {
        "Token": token,
        "BrandName": brandName,
        "ContactName": contactName,
        "CountryCode": countryCode,
        "EmailId": emailId,
        "MobileNo": mobileNo,
      };
}

class FmcgRegisterSellerUsecase
    implements UseCase<FmcgSellerSigninResponse, FmcgRegisterSellerParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgRegisterSellerUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, FmcgSellerSigninResponse>> call(
          FmcgRegisterSellerParams params) =>
      authenticationRepository.fmcgRegisterSeller(params);
}
