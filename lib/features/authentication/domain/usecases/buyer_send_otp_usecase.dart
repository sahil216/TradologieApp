import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/send_otp_usecase.dart';

import '../entities/send_otp_result.dart';
import '../repositories/authentication_repository.dart';

class BuyerSendOtpUsecase implements UseCase<SendOtpResult, SendOtpParams> {
  final AuthenticationRepository authenticationRepository;

  BuyerSendOtpUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, SendOtpResult>> call(SendOtpParams params) =>
      authenticationRepository.sendOtpBuyer(params);
}
