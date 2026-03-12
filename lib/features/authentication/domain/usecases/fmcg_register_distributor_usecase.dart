import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_seller_usecase.dart';

class FmcgRegisterDistributorUsecase
    implements UseCase<bool, FmcgRegisterDistributorParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgRegisterDistributorUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, bool>> call(FmcgRegisterDistributorParams params) =>
      authenticationRepository.fmcgRegisterDistributor(params);
}

class FmcgRegisterDistributorParams {
  final String name;
  final String mobile;
  final String countryCode;
  final String email;
  final String companyName;
  final String interestedBrandName;
  final String perferredLocation;

  FmcgRegisterDistributorParams({
    required this.name,
    required this.mobile,
    required this.countryCode,
    required this.email,
    required this.companyName,
    required this.interestedBrandName,
    required this.perferredLocation,
  });

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Mobile": mobile,
        "CountryCode": countryCode,
        "Email": email,
        "CompanyName": companyName,
        "InterestedBrandName": interestedBrandName,
        "PerferredLocation": perferredLocation,
      };
}
