import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/app/domain/repositories/app_repository.dart';

class CheckForceUpdateUsecase implements UseCase<bool, ForceUpdateParams> {
  final AppRepository appRepository;

  CheckForceUpdateUsecase({required this.appRepository});

  @override
  Future<Either<Failure, bool>> call(ForceUpdateParams params) async =>
      await appRepository.checkForceUpdate(params);
}

class ForceUpdateParams extends Equatable {
  final String token;
  final String appVersion;
  final bool isAndroid;
  const ForceUpdateParams(
      {required this.token, required this.appVersion, required this.isAndroid});
  @override
  List<Object?> get props => [token, appVersion];

  Future<Map<String, dynamic>> toJson() async =>
      {"Token": token, "AppVersion": appVersion, "IsAndroid": isAndroid};
}
