import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/buyer_login_success.dart';
import 'package:tradologie_app/features/authentication/domain/entities/login_success.dart';
import 'package:tradologie_app/features/authentication/domain/entities/send_otp_result.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/buyer_send_otp_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/buyer_signin_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/buyer_verify_otp_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/delete_account_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/sign_out_usecase.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/verify_otp_result.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final SendOtpUsecase sendOtpUsecase;
  final SignInUsecase signInUsecase;
  final RegisterUsecase registerUsecase;
  final VerifyOtpUsecase verifyOtpUsecase;
  final BuyerSigninUsecase buyerSigninUsecase;
  final SignOutUsecase signOutUsecase;
  final BuyerSendOtpUsecase buyerSendOtpUsecase;
  final BuyerVerifyOtpUsecase buyerVerifyOtpUsecase;
  final DeleteAccountUsecase deleteAccountUsecase;

  AuthenticationCubit({
    required this.sendOtpUsecase,
    required this.signInUsecase,
    required this.registerUsecase,
    required this.verifyOtpUsecase,
    required this.buyerSigninUsecase,
    required this.signOutUsecase,
    required this.buyerSendOtpUsecase,
    required this.buyerVerifyOtpUsecase,
    required this.deleteAccountUsecase,
  }) : super(AuthenticationInitial());

  Future<void> sendOtp(SendOtpParams params, bool isResend) async {
    emit(SendOtpIsLoading());
    Either<Failure, SendOtpResult> response = await sendOtpUsecase(params);
    emit(response.fold(
      (failure) => SendOtpError(failure: failure),
      (res) => SendOtpSuccess(data: res, isResend: isResend),
    ));
  }

  Future<void> verifyOtp(VerifyOtpParams params) async {
    emit(VerifyOtpIsLoading());
    Either<Failure, VerifyOtpResult> response = await verifyOtpUsecase(params);
    emit(response.fold(
      (failure) => VerifyOtpError(failure: failure),
      (res) => VerifyOtpSuccess(data: res),
    ));
  }

  Future<void> sendOtpBuyer(SendOtpParams params, bool isResend) async {
    emit(SendOtpIsLoading());
    Either<Failure, SendOtpResult> response = await buyerSendOtpUsecase(params);
    emit(response.fold(
      (failure) => SendOtpError(failure: failure),
      (res) => SendOtpSuccess(data: res, isResend: isResend),
    ));
  }

  Future<void> verifyOtpBuyer(VerifyOtpParams params) async {
    emit(VerifyOtpIsLoading());
    Either<Failure, VerifyOtpResult> response =
        await buyerVerifyOtpUsecase(params);
    emit(response.fold(
      (failure) => VerifyOtpError(failure: failure),
      (res) => VerifyOtpSuccess(data: res),
    ));
  }

  Future<void> signIn(SigninParams params) async {
    emit(SigninIsLoading());
    Either<Failure, LoginSuccess?> response = await signInUsecase(params);
    emit(response.fold(
      (failure) => SigninError(failure: failure),
      (res) => SigninSuccess(data: res),
    ));
  }

  Future<void> buyerSignIn(SigninParams params) async {
    emit(SigninIsLoading());
    Either<Failure, BuyerLoginSuccess?> response =
        await buyerSigninUsecase(params);
    emit(response.fold(
      (failure) => SigninError(failure: failure),
      (res) => BuyerSigninSuccess(data: res),
    ));
  }

  Future<void> register(RegisterParams params) async {
    emit(RegisterIsLoading());
    Either<Failure, bool> response = await registerUsecase(params);
    emit(response.fold(
      (failure) => RegisterError(failure: failure),
      (res) => RegisterSuccess(
        success: res,
      ),
    ));
  }

  Future<void> signOut(NoParams params) async {
    emit(SignOutIsLoading());
    Either<Failure, bool> response = await signOutUsecase(params);
    emit(response.fold(
      (failure) => SignOutError(failure: failure),
      (res) => SignOutSuccess(
        success: res,
      ),
    ));
  }

  Future<void> deleteAccount(DeleteAccountParams params) async {
    emit(DeleteAccountIsLoading());
    Either<Failure, bool> response = await deleteAccountUsecase(params);
    emit(response.fold(
      (failure) => DeleteAccountError(failure: failure),
      (res) => DeleteAccountSuccess(
        success: res,
      ),
    ));
  }
}
