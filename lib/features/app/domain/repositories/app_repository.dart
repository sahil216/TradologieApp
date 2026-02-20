import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/app/domain/usecases/check_force_update_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/verify_otp_result.dart';
import '../../../../core/error/failures.dart';

abstract class AppRepository {
  Future<Either<Failure, bool>> changeLang({required String langCode});
  Future<Either<Failure, bool>> checkForceUpdate(ForceUpdateParams params);
  Future<Either<Failure, VerifyOtpResult>> getCustomerDetailsById(
      NoParams params);
}
