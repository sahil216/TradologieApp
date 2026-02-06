import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/verify_otp_result.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/verify_otp_usecase.dart';

class BuyerVerifyOtpUsecase
    implements UseCase<VerifyOtpResult, VerifyOtpParams> {
  final AuthenticationRepository authenticationRepository;

  BuyerVerifyOtpUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, VerifyOtpResult>> call(VerifyOtpParams params) =>
      authenticationRepository.verifyOtpBuyer(params);
}
