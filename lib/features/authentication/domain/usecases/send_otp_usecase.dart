import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/authentication/domain/entities/send_otp_result.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/authentication_repository.dart';

class SendOtpUsecase implements UseCase<SendOtpResult, SendOtpParams> {
  final AuthenticationRepository authenticationRepository;

  SendOtpUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, SendOtpResult>> call(SendOtpParams params) =>
      authenticationRepository.sendOtp(params);
}

class SendOtpParams extends Equatable {
  final String mobileNo;
  final String countryCode;
  final String name;

  const SendOtpParams(
      {required this.mobileNo, required this.countryCode, required this.name});

  @override
  List<Object?> get props => [mobileNo, countryCode];

  Map<String, dynamic> toJson() => {
        "Token": "2018APR031848",
        "MobileNo": mobileNo,
        "CountryCode": countryCode,
        if (Constants.isBuyer == false) "VendorName": name,
        if (Constants.isBuyer == true) "CustomerName": name
      };
}
