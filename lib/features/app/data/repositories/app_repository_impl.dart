import 'package:dartz/dartz.dart';
import 'package:tradologie_app/features/app/domain/usecases/check_force_update_usecase.dart';
import '../../../../core/error/cache_failure.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/user_failure.dart';
import '../../domain/repositories/app_repository.dart';
import '../datasources/app_local_data_source.dart';

class AppRepositoryImpl implements AppRepository {
  final AppLocalDataSource appLocalDataSource;

  AppRepositoryImpl({required this.appLocalDataSource});
  @override
  Future<Either<Failure, bool>> changeLang({required String langCode}) async {
    try {
      final langIsChanged =
          await appLocalDataSource.changeLang(langCode: langCode);
      return Right(langIsChanged);
    } on CacheFailure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> checkForceUpdate(
      ForceUpdateParams params) async {
    try {
      final response = await appLocalDataSource.checkForceUpdate(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
