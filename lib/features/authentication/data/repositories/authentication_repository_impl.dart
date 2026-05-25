import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/data/models/country_code_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_brand_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_buyer_brand_partnership_type_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_buyer_category_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_buyer_distribution_coverage_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_buyer_login_success_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_country_code_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_seller_business_type_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_seller_exporting_products_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_seller_partnership_type_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_seller_product_category_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_seller_service_label_list_model.dart';
import 'package:tradologie_app/features/authentication/data/models/fmcg_seller_signin_response_model.dart';
import 'package:tradologie_app/features/authentication/data/models/login_success_model.dart';
import 'package:tradologie_app/features/authentication/data/models/send_otp_result_model.dart';
import 'package:tradologie_app/features/authentication/data/models/verify_otp_result_model.dart';
import 'package:tradologie_app/features/authentication/domain/entities/buyer_login_success.dart';
import 'package:tradologie_app/features/authentication/domain/entities/country_code_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_brands_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_brand_partnership_type_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_category_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_distribution_coverage_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_login_success.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_country_code_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_business_type_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_exporting_products_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_partnership_type_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_product_category_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_service_label_list.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_signin_response.dart';
import 'package:tradologie_app/features/authentication/domain/entities/send_otp_result.dart';
import 'package:tradologie_app/features/authentication/data/models/login_video_link_model.dart';
import 'package:tradologie_app/features/authentication/domain/entities/login_video_link.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/get_login_video_link_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/log_video_link_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_distributor_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_seller_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_seller_signin_usecase.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/user_failure.dart';
import '../../../../core/utils/app_strings.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/phone_number_utils.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../../domain/entities/ForgotpasswordsendotpSucess.dart';
import '../../domain/entities/login_success.dart';
import '../../domain/entities/verify_otp_fmcg_seller.dart';
import '../../domain/entities/verify_otp_result.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../../domain/entities/admin_login_success.dart';
import '../../domain/usecases/admin_login_usecase.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/forgotpasswordsendotpusecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/supplier_social_login_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../datasources/authentication_remote_data_source.dart';
import '../models/buyer_login_success_model.dart';
import '../models/admin_login_success_model.dart';
import '../models/forgot_password_send_otp_result_model.dart';
import '../models/verify_otp_fmcgseller_model.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource authenticationRemoteDataSource;
  final SharedPreferences sharedPreferences;

  AuthenticationRepositoryImpl({
    required this.authenticationRemoteDataSource,
    required this.sharedPreferences,
  });






  @override
  Future<Either<Failure, AdminLoginSuccess>> adminLogin(
      AdminLoginParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.adminLogin(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        Constants.isBuyer = false;
        Constants.isFmcg = false;
        Constants.isAdmin = true;

        final data = AdminLoginSuccessModel.fromJson(
            Map<String, dynamic>.from(response.data as Map));
        final secureStorage = SecureStorageService();

        await secureStorage.write(AppStrings.appSession, 'true');
        await secureStorage.write(AppStrings.isBuyer, 'false');
        await secureStorage.write(AppStrings.isFmcg, 'false');
        await secureStorage.write(AppStrings.isAdmin, 'true');

        Constants.token = data.apiVerificationCode ?? '';
        await secureStorage.write(
          AppStrings.apiVerificationCode,
          data.apiVerificationCode ?? '',
        );
        await secureStorage.write(
          AppStrings.loginId,
          data.loginId?.toString() ?? '',
        );
        await secureStorage.write(
          AppStrings.userId,
          params.userId,
        );

        return Right(data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }








  @override
  Future<Either<Failure, ForgotpasswordsendotpSuccess>> forgotpasswordsendotp(
      ForgotPasswordSendOtpParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.forgotpasswordsendotp(params);
      if (response != null && response.success) {
        return Right(
            ForgotPasswordSendOtpResultModel.fromJson(response.data));
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
        await _clearAdminSession(secureStorage);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = response.data["APIVerificationCode"] ?? "";

        await secureStorage.write(AppStrings.apiVerificationCode,
            response.data["APIVerificationCode"] ?? "");

        final mobile = readApiMobileField(
          response.data,
          fallback: params.mobileNo,
        );
        await secureStorage.write(AppStrings.mobileNo, mobile);

        var countryCode = normalizeCountryCodeForStorage(params.CountryCode);
        if (countryCode.isEmpty && mobile.isNotEmpty) {
          countryCode = parseHintPhoneNumber(mobile).countryCode;
        }
        if (countryCode.isNotEmpty) {
          await secureStorage.write(AppStrings.countryCode, countryCode);
        }

        await secureStorage.write(AppStrings.registrationStatus,
            response.data["RegistrationStatus"] ?? "");

        await secureStorage.write(
            AppStrings.projectType, response.data["Project_Type"] ?? "");

        await secureStorage.write(
            AppStrings.userId, response.data["UserID"] ?? "");

        await secureStorage.write(
            AppStrings.sellerTimeZone, response.data["UserTimeZone"] ?? "");

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
        await _clearAdminSession(secureStorage);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = response.data["APIVerificationCode"] ?? "";

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
  Future<Either<Failure, LoginSuccess?>> supplierLoginWithSocialMedia(
      SupplierSocialLoginParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .supplierLoginWithSocialMedia(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = response.data["APIVerificationCode"] ?? "";

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
  Future<Either<Failure, BuyerLoginSuccess?>> buyerLoginWithSocialMedia(
      SupplierSocialLoginParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .buyerLoginWithSocialMedia(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);
        final d = response.data;

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = d["APIVerificationCode"] ?? "";

        await secureStorage.write(
            AppStrings.apiVerificationCode, d["APIVerificationCode"] ?? "");

        await secureStorage.write(
            AppStrings.mobileNo, d["mobileNo"] ?? d["MobileNo"] ?? "");

        await secureStorage.write(AppStrings.registrationStatus,
            d["RegistrationStatus"] ?? "");

        await secureStorage.write(
            AppStrings.projectType, d["Project_Type"] ?? "");

        await secureStorage.write(AppStrings.userId, d["UserID"] ?? "");

        await secureStorage.write(
            AppStrings.customerId, d["CustomerID"]?.toString() ?? "");

        await secureStorage.write(AppStrings.customerName,
            (d["FullName"] ?? d["CustomerName"] ?? "").toString());
        await secureStorage.write(
            AppStrings.sellerTimeZone,
            d["UserTimeZone"] ?? d["SellerTimeZone"] ?? "");

        return Right(BuyerLoginSuccessModel.fromJson(
            Map<String, dynamic>.from(d as Map)));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, FmcgSellerSigninResponse>> fmcgSellerSignin(
      FmcgSellerSigninParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.fmcgSellerSignIn(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);
        FmcgSellerSigninResponse data =
            FmcgSellerSigninResponseModel.fromJson(response.data);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = data.fmcgUserDetail?.apiVerificationCode ?? "";

        await secureStorage.write(AppStrings.apiVerificationCode,
            data.fmcgUserDetail?.apiVerificationCode ?? "");

        await secureStorage.write(
            AppStrings.mobileNo, data.fmcgUserDetail?.mobile ?? "");

        await secureStorage.write(
            AppStrings.userId, data.fmcgUserDetail?.userId ?? "");

        await secureStorage.write(
            AppStrings.fmcgName, data.fmcgUserDetail?.fullName ?? "");

        await secureStorage.write(
            AppStrings.loginId, data.fmcgUserDetail?.loginId ?? "");

        await secureStorage.write(
            AppStrings.brandId, data.fmcgUserDetail?.brandId ?? "");
        await secureStorage.write(
            AppStrings.brandName, data.fmcgUserDetail?.brandName ?? "");
        await secureStorage.write(
            AppStrings.analyticsUrl, data.fmcgUserDetail?.analyticsUrl ?? "");
        Constants.analyticsUrl = data.fmcgUserDetail?.analyticsUrl ?? "";

        return Right(data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, FmcgBuyerLoginSuccess>> fmcgBuyerSignin(
      FmcgSellerSigninParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.fmcgBuyerSignIn(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);
        FmcgBuyerLoginSuccess data =
            FmcgBuyerLoginSuccessModel.fromJson(response.data);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = data.apiVerificationCode ?? "";

        await secureStorage.write(
            AppStrings.apiVerificationCode, data.apiVerificationCode ?? "");

        await secureStorage.write(AppStrings.mobileNo, data.mobile ?? "");

        await secureStorage.write(AppStrings.userId, data.userId ?? "");

        await secureStorage.write(AppStrings.fmcgName, data.name ?? "");

        await secureStorage.write(
            AppStrings.loginId, data.quotationUserId.toString());

        await secureStorage.write(AppStrings.brandId, data.brandId.toString());

        return Right(data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, FmcgBuyerLoginSuccess>> fmcgBuyerLoginWithSocialMedia(
      SupplierSocialLoginParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .fmcgBuyerLoginWithSocialMedia(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);
        final detail =
            Map<String, dynamic>.from(response.data as Map<dynamic, dynamic>);
        FmcgBuyerLoginSuccess data =
            FmcgBuyerLoginSuccessModel.fromJson(detail);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = data.apiVerificationCode ?? "";

        await secureStorage.write(
            AppStrings.apiVerificationCode, data.apiVerificationCode ?? "");

        await secureStorage.write(AppStrings.mobileNo, data.mobile ?? "");

        await secureStorage.write(AppStrings.userId, data.userId ?? "");

        await secureStorage.write(AppStrings.fmcgName, data.name ?? "");

        await secureStorage.write(
            AppStrings.loginId, data.quotationUserId.toString());

        await secureStorage.write(AppStrings.brandId, data.brandId.toString());

        return Right(data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, FmcgSellerSigninResponse>>
      fmcgSellerLoginWithSocialMedia(SupplierSocialLoginParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .fmcgSellerLoginWithSocialMedia(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);
        final detail =
            Map<String, dynamic>.from(response.data as Map<dynamic, dynamic>);
        FmcgSellerSigninResponse data =
            FmcgSellerSigninResponseModel.fromJson(detail);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = data.fmcgUserDetail?.apiVerificationCode ?? "";

        await secureStorage.write(AppStrings.apiVerificationCode,
            data.fmcgUserDetail?.apiVerificationCode ?? "");

        await secureStorage.write(
            AppStrings.mobileNo, data.fmcgUserDetail?.mobile ?? "");

        await secureStorage.write(
            AppStrings.userId, data.fmcgUserDetail?.userId ?? "");

        await secureStorage.write(
            AppStrings.fmcgName, data.fmcgUserDetail?.fullName ?? "");

        await secureStorage.write(
            AppStrings.loginId, data.fmcgUserDetail?.loginId ?? "");

        await secureStorage.write(
            AppStrings.brandId, data.fmcgUserDetail?.brandId ?? "");
        await secureStorage.write(
            AppStrings.brandName, data.fmcgUserDetail?.brandName ?? "");
        await secureStorage.write(
            AppStrings.analyticsUrl, data.fmcgUserDetail?.analyticsUrl ?? "");
        Constants.analyticsUrl = data.fmcgUserDetail?.analyticsUrl ?? "";

        return Right(data);
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
        await _clearAdminSession(secureStorage);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = response.data["APIVerificationCode"] ?? "";

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
        await secureStorage.write(
            AppStrings.sellerTimeZone, response.data["UserTimeZone"] ?? "");

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
  Future<Either<Failure, String>> adminLogout(NoParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.adminLogout(params);
      if (response != null && response.success) {
        final secureStorage = SecureStorageService();
        Constants.isLogin = false;
        Constants.token = '';
        await _clearAdminSession(secureStorage);
        await secureStorage.delete(AppStrings.apiVerificationCode);
        await secureStorage.write(AppStrings.appSession, 'false');
        await secureStorage.write(AppStrings.isBuyer, 'false');
        await secureStorage.write(AppStrings.isFmcg, 'false');
        final message = response.message.trim();
        return Right(
          message.isNotEmpty ? message : 'Admin logout successfully!',
        );
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

  @override
  Future<Either<Failure, FmcgSellerSigninResponse>> fmcgRegisterSeller(
      FmcgRegisterSellerParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.fmcgRegisterSeller(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);
        FmcgSellerSigninResponse data =
            FmcgSellerSigninResponseModel.fromJson(response.data);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = data.fmcgUserDetail?.apiVerificationCode ?? "";

        await secureStorage.write(AppStrings.apiVerificationCode,
            data.fmcgUserDetail?.apiVerificationCode ?? "");

        await secureStorage.write(
            AppStrings.mobileNo, data.fmcgUserDetail?.mobile ?? "");

        await secureStorage.write(
            AppStrings.userId, data.fmcgUserDetail?.userId ?? "");

        await secureStorage.write(
            AppStrings.fmcgName, data.fmcgUserDetail?.fullName ?? "");

        await secureStorage.write(
            AppStrings.loginId, data.fmcgUserDetail?.loginId ?? "");

        await secureStorage.write(
            AppStrings.brandId, data.fmcgUserDetail?.brandId ?? "");
        await secureStorage.write(
            AppStrings.brandName, data.fmcgUserDetail?.brandName ?? "");

        return Right(data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgCountryCodeList>>> fmcgGetCountryCodeList(
      NoParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.fmcgGetCountryCodeList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgCountryCodeListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgBrandsList>>> fmcgBrandsList(
      NoParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.fmcgBrandsList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgBrandsListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, FmcgBuyerLoginSuccess>> fmcgRegisterDistributor(
      FmcgRegisterDistributorParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.fmcgRegisterDistributor(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);
        FmcgBuyerLoginSuccess data =
            FmcgBuyerLoginSuccessModel.fromJson(response.data);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = data.apiVerificationCode ?? "";

        await secureStorage.write(
            AppStrings.apiVerificationCode, data.apiVerificationCode ?? "");

        await secureStorage.write(AppStrings.mobileNo, data.mobile ?? "");

        await secureStorage.write(AppStrings.userId, data.userId ?? "");

        await secureStorage.write(AppStrings.fmcgName, data.name ?? "");

        await secureStorage.write(
            AppStrings.loginId, data.quotationUserId.toString());

        await secureStorage.write(AppStrings.brandId, data.brandId.toString());

        return Right(data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgBuyerCategoryList>>> fmcgBuyerCategoryList(
      NoParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.fmcgBuyerCategoryList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgBuyerCategoryListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgBuyerBrandPartnershipTypeList>>>
      fmcgBuyerBrandPartnershipList(NoParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .fmcgBuyerBrandPartnershipList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgBuyerBrandPartnershipTypeListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgBuyerDistributionCoverageList>>>
      fmcgBuyerDistributionCoverageList(NoParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .fmcgBuyerDistributionCoverageList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgBuyerDistributionCoverageListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgSellerBusinessTypeList>>>
      fmcgSellerBusinessTypeList(NoParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .fmcgSellerBusinessTypeList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgSellerBusinessTypeListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgSellerProductCategoryList>>>
      fmcgSellerProductCategoryList(NoParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .fmcgSellerProductCategoryList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgSellerProductCategoryListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgSellerPartnershipTypeList>>>
      fmcgSellerPartnershipTypeList(NoParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .fmcgSellerPartnershipTypeList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgSellerPartnershipTypeListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgSellerServiceLabelList>>>
      fmcgSellerServiceLabelList(NoParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .fmcgSellerServiceLabelList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgSellerServiceLabelListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<FmcgSellerExportingProductsList>>>
      fmcgSellerExportingProductsList(NoParams params) async {
    try {
      final response = await authenticationRemoteDataSource
          .fmcgSellerExportingProductsList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => FmcgSellerExportingProductsListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }




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
  Future<Either<Failure, SendOtpResult>> sendOtpFMCGseller(SendOtpParams params) async {
    try {
      final response = await authenticationRemoteDataSource.sendFMCGSellerOtp(params);
      if (response != null && response.success) {
        return Right(SendOtpResultModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, SendOtpResult>> sendOtpFMCGbuyer(
      SendOtpParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.sendFMCGBuyerOtp(params);
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
        Constants.token = response.data["APIVerificationCode"] ?? "";
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);

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
  Future<Either<Failure, FMCGSellerUserDetail>> verifyOtpFMCGSeller(
      VerifyOtpParams params) async {
    try {
      final response = await authenticationRemoteDataSource.verifyOtpFMCGSeller(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        Constants.token = response.data["FMCGUserDetail"]["ApiVerificationCode"] ?? "";
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);

        await secureStorage.write(AppStrings.appSession, "true");

        await secureStorage.write(AppStrings.apiVerificationCode,
            response.data["FMCGUserDetail"]["ApiVerificationCode"] ?? "");

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
        return Right(FMCGSellerVerifyOtpModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, FmcgBuyerLoginSuccess>> verifyOtpFMCGbuyer(
      VerifyOtpParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.verifyOtpFMCGBuyer(params);
      if (response != null && response.success) {
        Constants.isLogin = true;
        SecureStorageService secureStorage = SecureStorageService();
        await _clearAdminSession(secureStorage);
        final data = FmcgBuyerLoginSuccessModel.fromJson(response.data);

        await secureStorage.write(AppStrings.appSession, "true");
        Constants.token = data.apiVerificationCode ?? "";

        await secureStorage.write(
            AppStrings.apiVerificationCode, data.apiVerificationCode ?? "");

        final mobile = data.mobile?.trim().isNotEmpty == true
            ? data.mobile!.trim()
            : readApiMobileField(
                Map<dynamic, dynamic>.from(response.data as Map),
                fallback: params.mobileNo,
              );

        await secureStorage.write(AppStrings.mobileNo, mobile);

        var countryCode = normalizeCountryCodeForStorage(
          data.countryCode ?? params.CountryCode,
        );
        if (countryCode.isEmpty && mobile.isNotEmpty) {
          countryCode = parseHintPhoneNumber(mobile).countryCode;
        }
        if (countryCode.isNotEmpty) {
          await secureStorage.write(AppStrings.countryCode, countryCode);
        }

        await secureStorage.write(AppStrings.userId, data.userId ?? "");

        await secureStorage.write(AppStrings.fmcgName, data.name ?? "");

        await secureStorage.write(
            AppStrings.loginId, data.quotationUserId.toString());

        await secureStorage.write(AppStrings.brandId, data.brandId.toString());

        return Right(data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  Future<void> _clearAdminSession(SecureStorageService secureStorage) async {
    Constants.isAdmin = false;
    await secureStorage.write(AppStrings.isAdmin, 'false');
  }

  @override
  Future<Either<Failure, LoginVideoLink>> getLoginVideoLink(
      GetLoginVideoLinkParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.getLoginVideoLink(params);
      if (response != null && response.success) {
        final data = response.data;
        if (data is Map) {
          final link = LoginVideoLinkModel.fromJson(
            Map<String, dynamic>.from(data),
          );
          if (link.linkUrl.trim().isEmpty) {
            return Left(UserFailure('Video link not available', response.code));
          }
          return Right(link);
        }
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> logVideoLink(LogVideoLinkParams params) async {
    try {
      final response =
          await authenticationRemoteDataSource.logVideoLink(params);
      if (response != null && response.success) {
        return const Right(true);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
