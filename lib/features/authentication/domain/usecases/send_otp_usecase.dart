import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/authentication/domain/entities/country_code_list.dart';
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


class SendOtpUsecaseFMCGseller implements UseCase<SendOtpResult, SendOtpParams> {
  final AuthenticationRepository authenticationRepository;

  SendOtpUsecaseFMCGseller({required this.authenticationRepository});
  @override
  Future<Either<Failure, SendOtpResult>> call(SendOtpParams params) =>
      authenticationRepository.sendOtpFMCGseller(params);
}

class SendOtpParams extends Equatable {
  final String mobileNo;
  final CountryCodeList countryCode;
  final String name;

  const SendOtpParams(
      {required this.mobileNo, required this.countryCode, required this.name});

  @override
  List<Object?> get props => [mobileNo, countryCode];

  Map<String, dynamic> toJson() =>
      {


        "Token": "2018APR031848",
        "MobileNo": mobileNo,


        //"CountryCode": "+91",



          // if (Constants.isFmcg && Constants.isBuyer)
          // yet to implement

        if (!Constants.isFmcg && Constants.isBuyer)...{
          "VendorName": name,
          "CountryCode": countryCode.countryValue,
        },


        if (!Constants.isFmcg && !Constants.isBuyer)...{
          "CustomerName": name,
          "CountryCode": countryCode.countryValue,
        },


        if (Constants.isFmcg && !Constants.isBuyer)...{
          "Name": name,
          "CountryCode": formatCountryCode(countryCode.countryValue!),
          // Non-FMCG logic
        }


      };


}

String formatCountryCode(String input) {
  return "+${input.split('~').last}";
}
