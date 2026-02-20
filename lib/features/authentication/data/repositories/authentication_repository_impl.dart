import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/data/models/country_code_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/login_success_model.dart';
import 'package:tradologie_app/features/authentication/data/models/send_otp_result_model.dart';
import 'package:tradologie_app/features/authentication/data/models/verify_otp_result_model.dart';
import 'package:tradologie_app/features/authentication/domain/entities/buyer_login_success.dart';
import 'package:tradologie_app/features/authentication/domain/entities/country_code_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/send_otp_result.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/delete_account_usecase.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/user_failure.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../../domain/entities/login_success.dart';
import '../../domain/entities/verify_otp_result.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../datasources/authentication_remote_data_source.dart';
import '../models/buyer_login_success_model.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;
  final SharedPreferences sharedPreferences;

  AuthenticationRepositoryImpl({
    required this.authenticationRemoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, SendOtpResult>> sendOtp(SendOtpParams params) async {
    try {
      final response = await authenticationRemoteDataSource.sendOtp(params);
      if (response != null && response.success) {
        return Right(SendOtpResultModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, VerifyOtpResult>> verifyOtp(
      VerifyOtpParams params) async {
    try {
      final response = await authenticationRemoteDataSource.verifyOtp(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();

        await secureStorage.write(AppStrings.appSession, "true");

        await secureStorage.write(AppStrings.apiVerificationCode,
            response.data["APIVerificationCode"] ?? "");

        await secureStorage.write(
            AppStrings.imageExist, response.data["ImageExist"] ?? "");

        await secureStorage.write(
            AppStrings.sellerTimeZone, response.data["SellerTimeZone"] ?? "");

        await secureStorage.write(
            AppStrings.mobileNo, response.data["MobileNo"] ?? "");

        await secureStorage.write(AppStrings.registrationStatus,
            response.data["RegistrationStatus"] ?? "");

        await secureStorage.write(
            AppStrings.projectType, response.data["Project_Type"] ?? "");

        await secureStorage.write(
            AppStrings.userId, response.data["UserID"] ?? "");

        await secureStorage.write(
            AppStrings.vendorName, response.data["VendorName"] ?? "");

        await secureStorage.write(
            AppStrings.vendorId, response.data["VendorID"].toString());
        return Right(VerifyOtpResultModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, SendOtpResult>> sendOtpBuyer(
      SendOtpParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.sendOtpBuyer(params);
      if (response != null && response.success) {
        return Right(SendOtpResultModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, VerifyOtpResult>> verifyOtpBuyer(
      VerifyOtpParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.verifyOtpBuyer(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();

        await secureStorage.write(AppStrings.appSession, "true");

        await secureStorage.write(AppStrings.apiVerificationCode,
            response.data["APIVerificationCode"] ?? "");

        await secureStorage.write(
            AppStrings.mobileNo, response.data["mobileNo"] ?? "");

        await secureStorage.write(AppStrings.registrationStatus,
            response.data["RegistrationStatus"] ?? "");

        await secureStorage.write(
            AppStrings.projectType, response.data["Project_Type"] ?? "");

        await secureStorage.write(
            AppStrings.userId, response.data["UserID"] ?? "");

        await secureStorage.write(
            AppStrings.userTimeZone, response.data["UserTimeZone"] ?? "");

        await secureStorage.write(
            AppStrings.customerId, response.data["CustomerID"].toString());
        await secureStorage.write(
            AppStrings.customerName, response.data["CustomerName"] ?? "");
        return Right(VerifyOtpResultModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, LoginSuccess>> signIn(SigninParams params) async {
    try {
      final response = await authenticationRemoteDataSource.signIn(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();

        await secureStorage.write(AppStrings.appSession, "true");

        await secureStorage.write(AppStrings.apiVerificationCode,
            response.data["APIVerificationCode"] ?? "");

        await secureStorage.write(
            AppStrings.imageExist, response.data["ImageExist"] ?? "");

        await secureStorage.write(
            AppStrings.sellerTimeZone, response.data["SellerTimeZone"] ?? "");

        await secureStorage.write(
            AppStrings.mobileNo, response.data["MobileNo"] ?? "");

        await secureStorage.write(AppStrings.registrationStatus,
            response.data["RegistrationStatus"] ?? "");

        await secureStorage.write(
            AppStrings.projectType, response.data["Project_Type"] ?? "");

        await secureStorage.write(
            AppStrings.userId, response.data["UserID"] ?? "");

        await secureStorage.write(
            AppStrings.vendorName, response.data["VendorName"] ?? "");

        await secureStorage.write(
            AppStrings.vendorId, response.data["VendorID"].toString());

        return Right(LoginSuccessModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, BuyerLoginSuccess>> buyerSignIn(
      SigninParams params) async {
    try {
      final response = await authenticationRemoteDataSource.buyerSignIn(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();

        await secureStorage.write(AppStrings.appSession, "true");

        await secureStorage.write(AppStrings.apiVerificationCode,
            response.data["APIVerificationCode"] ?? "");

        await secureStorage.write(
            AppStrings.mobileNo, response.data["mobileNo"] ?? "");

        await secureStorage.write(AppStrings.registrationStatus,
            response.data["RegistrationStatus"] ?? "");

        await secureStorage.write(
            AppStrings.projectType, response.data["Project_Type"] ?? "");

        await secureStorage.write(
            AppStrings.userId, response.data["UserID"] ?? "");

        await secureStorage.write(
            AppStrings.customerId, response.data["CustomerID"].toString());

        await secureStorage.write(
            AppStrings.customerName, response.data["FullName"].toString());

        return Right(BuyerLoginSuccessModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> register(RegisterParams params) async {
    try {
      final response = await authenticationRemoteDataSource.register(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAccount(
      DeleteAccountParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.deleteAccount(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> signOut(NoParams params) async {
    try {
      final response = await authenticationRemoteDataSource.signOut(params);
      if (response != null && response.success) {
        return Right(response.success);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<CountryCodeList>>> getCountryCodeList(
      NoParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.getCountryCodeList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => CountryCodeListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
