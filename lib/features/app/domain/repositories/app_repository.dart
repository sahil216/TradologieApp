import 'package:dartz/dartz.dart';
import 'package:tradologie_app/features/app/domain/usecases/check_force_update_usecase.dart';
import '../../../../core/error/failures.dart';

abstract class AppRepository {
  Future<Either<Failure, bool>> changeLang({required String langCode});
  Future<Either<Failure, bool>> checkForceUpdate(ForceUpdateParams params);
}
