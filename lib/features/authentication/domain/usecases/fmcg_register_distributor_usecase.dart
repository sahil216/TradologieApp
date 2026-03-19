import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_login_success.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgRegisterDistributorUsecase
    implements UseCase<FmcgBuyerLoginSuccess, FmcgRegisterDistributorParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgRegisterDistributorUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, FmcgBuyerLoginSuccess>> call(
          FmcgRegisterDistributorParams params) =>
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
  final String manufacturer;
  final String model;
  final String osVersionRelease;
  final String appVersion;
  final String fcmToken;
  final String osType;
  final String deviceId;

  FmcgRegisterDistributorParams({
    required this.name,
    required this.mobile,
    required this.countryCode,
    required this.email,
    required this.companyName,
    required this.interestedBrandName,
    required this.perferredLocation,
    required this.manufacturer,
    required this.model,
    required this.osVersionRelease,
    required this.appVersion,
    required this.fcmToken,
    required this.osType,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Mobile": mobile,
        "CountryCode": countryCode,
        "Email": email,
        "CompanyName": companyName,
        "InterestedBrandName": interestedBrandName,
        "PerferredLocation": perferredLocation,
        "Manufacturer": manufacturer,
        "Model": model,
        "OSVersionRelease": osVersionRelease,
        "AppVersion": appVersion,
        "FcmToken": fcmToken,
        "OSType": osType,
        "DeviceID": Constants.deviceID
      };
}
