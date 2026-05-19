import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/admin_login_success.dart';
import '../repositories/authentication_repository.dart';

class AdminLoginUsecase implements UseCase<AdminLoginSuccess, AdminLoginParams> {
  final AuthenticationRepository authenticationRepository;

  AdminLoginUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, AdminLoginSuccess>> call(AdminLoginParams params) =>
      authenticationRepository.adminLogin(params);
}

class AdminLoginParams extends Equatable {
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

  const AdminLoginParams({
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

  Map<String, dynamic> toJson() => {
        'UserID': userId,
        'Password': password,
        'Token': token,
        'Manufacturer': manufacturer,
        'Model': model,
        'OSVersionRelease': osVersionRelease,
        'AppVersion': appVersion,
        'FcmToken': fcmToken,
        'OSType': osType,
        'DeviceID': deviceId,
      };
}
