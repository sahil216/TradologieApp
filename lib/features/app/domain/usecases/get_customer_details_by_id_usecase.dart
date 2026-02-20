import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/app/domain/repositories/app_repository.dart';
import 'package:tradologie_app/features/authentication/domain/entities/verify_otp_result.dart';

class GetCustomerDetailsByIdUsecase
    implements UseCase<VerifyOtpResult, NoParams> {
  final AppRepository appRepository;

  GetCustomerDetailsByIdUsecase({required this.appRepository});

  @override
  Future<Either<Failure, VerifyOtpResult>> call(NoParams params) async =>
      await appRepository.getCustomerDetailsById(params);
}
