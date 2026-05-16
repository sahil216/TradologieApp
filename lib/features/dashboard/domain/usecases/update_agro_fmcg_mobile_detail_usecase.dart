import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/respositories/dashboard_repository.dart';

class UpdateAgroFmcgMobileDetailUsecase
    implements UseCase<String, UpdateAgroFmcgMobileDetailParams> {
  final DashboardRepository dasboardRepository;

  UpdateAgroFmcgMobileDetailUsecase({required this.dasboardRepository});

  @override
  Future<Either<Failure, String>> call(UpdateAgroFmcgMobileDetailParams params) =>
      dasboardRepository.updateAgroFmcgMobileDetail(params);
}

class UpdateAgroFmcgMobileDetailParams extends Equatable {
  final String token;
  final String type;
  final String id;
  final String countryCode;
  final String mobile;
  final String deviceID;

  const UpdateAgroFmcgMobileDetailParams({
    required this.token,
    required this.type,
    required this.id,
    required this.countryCode,
    required this.mobile,
    required this.deviceID,
  });

  @override
  List<Object?> get props => [token, type, id, countryCode, mobile, deviceID];

  Map<String, dynamic> toJson() {
    final code = countryCode.trim();
    return {
      'Token': token,
      'Type': type,
      'Id': id,
      'CountryCode': code.startsWith('+') ? code : '+$code',
      'Mobile': mobile,
      'DeviceID': deviceID,
    };
  }
}
