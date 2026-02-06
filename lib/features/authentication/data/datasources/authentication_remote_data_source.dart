import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/delete_account_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/verify_otp_usecase.dart';
import 'package:tradologie_app/features/authentication/presentation/cubit/authentication_cubit.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/response_wrapper/response_wrapper.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';

abstract class AuthenticationRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> signIn(SigninParams params);
  Future<ResponseWrapper<dynamic>?> buyerSignIn(SigninParams params);
  Future<ResponseWrapper<dynamic>?> register(RegisterParams params);
  Future<ResponseWrapper<dynamic>?> sendOtp(SendOtpParams params);
  Future<ResponseWrapper<dynamic>?> verifyOtp(VerifyOtpParams params);
  Future<ResponseWrapper<dynamic>?> sendOtpBuyer(SendOtpParams params);
  Future<ResponseWrapper<dynamic>?> verifyOtpBuyer(VerifyOtpParams params);
  Future<ResponseWrapper<dynamic>?> signOut(NoParams params);
  Future<ResponseWrapper<dynamic>?> deleteAccount(DeleteAccountParams params);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  ApiConsumer apiConsumer;

  AuthenticationRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ResponseWrapper<dynamic>?> signIn(SigninParams params) async {
    return await apiConsumer.post(
      EndPoints.signIn(UserType.supplier),
      body: await params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> buyerSignIn(SigninParams params) async {
    return await apiConsumer.post(
      EndPoints.signIn(UserType.buyer),
      body: await params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> register(RegisterParams params) async {
    return await apiConsumer.post(
      EndPoints.register,
      body: await params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> sendOtp(SendOtpParams params) async {
    return await apiConsumer.post(
      EndPoints.sendOtp(UserType.supplier),
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> verifyOtp(VerifyOtpParams params) async {
    return await apiConsumer.post(
      EndPoints.verifyOtp(UserType.supplier),
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> sendOtpBuyer(SendOtpParams params) async {
    return await apiConsumer.post(
      EndPoints.sendOtpBuyer(UserType.buyer),
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> verifyOtpBuyer(
      VerifyOtpParams params) async {
    return await apiConsumer.post(
      EndPoints.verifyOtpBuyer(UserType.buyer),
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> signOut(NoParams params) async {
    SecureStorageService storage = SecureStorageService();
    var dparams = await DefaultParams.fromStorage(storage);
    return await apiConsumer.post(
      Constants.isBuyer == true
          ? EndPoints.signOut(UserType.buyer)
          : EndPoints.signOut(UserType.supplier),
      body: dparams.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> deleteAccount(
      DeleteAccountParams params) async {
    return await apiConsumer.post(
      Constants.isBuyer == true
          ? EndPoints.deleteAccount(UserType.buyer)
          : EndPoints.deleteAccount(UserType.supplier),
      body: params.toJson(),
    );
  }
}
