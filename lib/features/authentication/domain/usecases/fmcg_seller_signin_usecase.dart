import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_signin_response.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgSellerSigninUsecase
    implements UseCase<FmcgSellerSigninResponse, FmcgSellerSigninParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgSellerSigninUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, FmcgSellerSigninResponse>> call(
          FmcgSellerSigninParams params) =>
      authenticationRepository.fmcgSellerSignin(params);
}

class FmcgSellerSigninParams extends Equatable {
  final String userId;
  final String password;
  final String token;
  final String manufacturer;
  final String model;
  final String osVersionRelease;
  final String appVersion;
  final String fcmToken;
  final String osType;
  final String deviceId;

  const FmcgSellerSigninParams({
    required this.userId,
    required this.password,
    required this.token,
    required this.manufacturer,
    required this.model,
    required this.osVersionRelease,
    required this.appVersion,
    required this.fcmToken,
    required this.osType,
    required this.deviceId,
  });

  @override
  List<Object?> get props => [userId, password, token];
  Future<Map<String, dynamic>> toJson() async => {
        "UserID": userId,
        "Password": password,
        "Token": token,
        "Manufacturer": manufacturer,
        "Model": model,
        "OSVersionRelease": osVersionRelease,
        "AppVersion": appVersion,
        "FcmToken": fcmToken,
        "OSType": osType,
        "DeviceID": Constants.deviceID
      };
}
