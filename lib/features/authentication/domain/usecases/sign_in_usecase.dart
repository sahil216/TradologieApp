import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/authentication/domain/entities/login_success.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

class SignInUsecase implements UseCase<LoginSuccess?, SigninParams> {
  final AuthenticationRepository authenticationRepository;

  SignInUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, LoginSuccess?>> call(SigninParams params) =>
      authenticationRepository.signIn(params);
}

class SigninParams extends Equatable {
  final String username;
  final String password;
  final String deviceId;
  final String osType;
  final String fcmToken;
  final String manufacturer;
  final String model;
  final String osVersionRelease;
  final String appVersion;

  const SigninParams({
    required this.username,
    required this.password,
    required this.deviceId,
    required this.osType,
    required this.fcmToken,
    required this.manufacturer,
    required this.model,
    required this.osVersionRelease,
    required this.appVersion,
  });

  @override
  List<Object?> get props => [username, password];
  Future<Map<String, dynamic>> toJson() async => {
        "UserID": username,
        "Password": password,
        "Manufacturer": manufacturer,
        "Model": model,
        "OSVersionRelease": osVersionRelease,
        "AppVersion": appVersion,
        "FcmToken": fcmToken,
        "OSType": osType,
        "DeviceID": deviceId
      };
}
