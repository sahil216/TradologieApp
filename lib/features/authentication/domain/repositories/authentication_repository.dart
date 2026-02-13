import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/buyer_login_success.dart';
import 'package:tradologie_app/features/authentication/domain/entities/country_code_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/login_success.dart';
import 'package:tradologie_app/features/authentication/domain/entities/send_otp_result.dart';
import 'package:tradologie_app/features/authentication/domain/entities/verify_otp_result.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/delete_account_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/verify_otp_usecase.dart';

import '../../../../core/error/failures.dart';
import '../usecases/register_usecase.dart';
import '../usecases/sign_in_usecase.dart';

abstract class AuthenticationRepository {
  Future<Either<Failure, SendOtpResult>> sendOtp(SendOtpParams params);
  Future<Either<Failure, VerifyOtpResult>> verifyOtp(VerifyOtpParams params);
  Future<Either<Failure, SendOtpResult>> sendOtpBuyer(SendOtpParams params);
  Future<Either<Failure, VerifyOtpResult>> verifyOtpBuyer(
      VerifyOtpParams params);
  Future<Either<Failure, LoginSuccess?>> signIn(SigninParams params);
  Future<Either<Failure, BuyerLoginSuccess?>> buyerSignIn(SigninParams params);
  Future<Either<Failure, bool>> register(RegisterParams params);
  Future<Either<Failure, bool>> signOut(NoParams params);
  Future<Either<Failure, bool>> deleteAccount(DeleteAccountParams params);
  Future<Either<Failure, List<CountryCodeList>>> getCountryCodeList(
      NoParams params);
}
