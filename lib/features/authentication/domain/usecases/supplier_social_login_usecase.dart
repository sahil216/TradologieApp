import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/login_success.dart';
import '../repositories/authentication_repository.dart';

class SupplierSocialLoginUsecase
    implements UseCase<LoginSuccess?, SupplierSocialLoginParams> {
  final AuthenticationRepository authenticationRepository;

  SupplierSocialLoginUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, LoginSuccess?>> call(SupplierSocialLoginParams params) =>
      authenticationRepository.supplierLoginWithSocialMedia(params);
}

class SupplierSocialLoginParams extends Equatable {
  final String token;
  final String userId;
  final String name;
  final String socialMedia;
  final String manufacturer;
  final String model;
  final String osVersionRelease;
  final String appVersion;
  final String fcmToken;
  final String osType;
  final String deviceId;

  const SupplierSocialLoginParams({
    required this.token,
    required this.userId,
    required this.name,
    required this.socialMedia,
    required this.manufacturer,
    required this.model,
    required this.osVersionRelease,
    required this.appVersion,
    required this.fcmToken,
    required this.osType,
    required this.deviceId,
  });

  Map<String, dynamic> toJson() => {
        'Token': token,
        'UserID': userId,
        'Name': name,
        'SocialMedia': socialMedia,
        'Manufacturer': manufacturer,
        'Model': model,
        'OSVersionRelease': osVersionRelease,
        'AppVersion': appVersion,
        'FcmToken': fcmToken,
        'OSType': osType,
        'DeviceID': deviceId,
      };

  @override
  List<Object?> get props => [
        token,
        userId,
        name,
        socialMedia,
        manufacturer,
        model,
        osVersionRelease,
        appVersion,
        fcmToken,
        osType,
        deviceId,
      ];
}
