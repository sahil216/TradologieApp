import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ForgotpasswordsendotpSucess.dart';
import '../repositories/authentication_repository.dart';

class ForgotpasswordUsecase
    implements UseCase<ForgotpasswordsendotpSuccess, ForgotPasswordSendOtpParams> {
  final AuthenticationRepository authenticationRepository;

  ForgotpasswordUsecase({required this.authenticationRepository});

  @override
  Future<Either<Failure, ForgotpasswordsendotpSuccess>> call(
          ForgotPasswordSendOtpParams params) =>
      authenticationRepository.forgotpasswordsendotp(params);
}

class ForgotPasswordSendOtpParams extends Equatable {
  final String userId;
  final String token;

  const ForgotPasswordSendOtpParams({
    required this.userId,
    required this.token,
  });

  @override
  List<Object?> get props => [userId, token];

  Map<String, dynamic> toJson() => {
        "UserID": userId,
        "Token": token,
      };
}
