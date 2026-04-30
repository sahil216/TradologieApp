import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/verify_otp_fmcg_seller.dart';
import '../entities/verify_otp_result.dart';
import '../repositories/authentication_repository.dart';

class VerifyOtpUsecase implements UseCase<VerifyOtpResult, VerifyOtpParams> {
  final AuthenticationRepository authenticationRepository;

  VerifyOtpUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, VerifyOtpResult>> call(VerifyOtpParams params) =>
      authenticationRepository.verifyOtp(params);
}

class VerifyOtpUsecaseFMCGSeller implements UseCase<FMCGSellerUserDetail, VerifyOtpParams> {
  final AuthenticationRepository authenticationRepository;

  VerifyOtpUsecaseFMCGSeller({required this.authenticationRepository});

  @override
  Future<Either<Failure, FMCGSellerUserDetail>> call(VerifyOtpParams params) =>
      authenticationRepository.verifyOtpFMCGSeller(params);
}

class VerifyOtpParams extends Equatable {
  final String mobileNo;
  final String otp;
  final String deviceId;
  final String osType;
  final String fcmToken;
  final String manufacturer;
  final String model;
  final String osVersionRelease;
  final String appVersion;
  final String CountryCode;
  final String Name;

  const VerifyOtpParams({
    required this.mobileNo,
    required this.otp,
    required this.deviceId,
    required this.osType,
    required this.fcmToken,
    required this.manufacturer,
    required this.model,
    required this.osVersionRelease,
    required this.appVersion,
    required this.CountryCode,
    required this.Name,
  });

  @override
  List<Object?> get props => [
        mobileNo,
        otp,
        deviceId,
        osType,
        fcmToken,
        manufacturer,
        model,
        osVersionRelease,
        appVersion,
        CountryCode,
        Name,
      ];

  Map<String, dynamic> toJson() => {
        if (Constants.isFmcg && !Constants.isBuyer) ...{
          "Name": Name,
          "CountryCode": formatCountryCode(CountryCode),
        },

        "Token": "2018APR031848",
        "MobileNo": mobileNo,
        "OTP": otp,
        "Manufacturer": manufacturer,
        "Model": model,
        "OSVersionRelease": osVersionRelease,
        "AppVersion": appVersion,
        "FcmToken": fcmToken,
        "OSType": osType,
        "DeviceID": deviceId
      };
}

String formatCountryCode(String input) {
  return "+${input.split('~').last}";
}
