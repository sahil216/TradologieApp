import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/verify_otp_result.dart';
import '../repositories/authentication_repository.dart';

class VerifyOtpUsecase implements UseCase<VerifyOtpResult, VerifyOtpParams> {
  final AuthenticationRepository authenticationRepository;

  VerifyOtpUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, VerifyOtpResult>> call(VerifyOtpParams params) =>
      authenticationRepository.verifyOtp(params);
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
        appVersion
      ];
  Map<String, dynamic> toJson() => {
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
