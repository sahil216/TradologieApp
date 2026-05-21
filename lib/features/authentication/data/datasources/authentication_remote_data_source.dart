import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/delete_account_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_distributor_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_seller_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_seller_signin_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/verify_otp_usecase.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/response_wrapper/response_wrapper.dart';
import '../../../../core/utils/secure_storage_service.dart';
import '../../domain/usecases/admin_login_usecase.dart';
import '../../domain/usecases/forgotpasswordsendotpusecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/sign_in_usecase.dart';
import '../../domain/usecases/supplier_social_login_usecase.dart';

abstract class AuthenticationRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> adminLogin(AdminLoginParams params);
  Future<ResponseWrapper<dynamic>?> adminLogout(NoParams params);
  Future<ResponseWrapper<dynamic>?> signIn(SigninParams params);
  Future<ResponseWrapper<dynamic>?> supplierLoginWithSocialMedia(
      SupplierSocialLoginParams params);
  Future<ResponseWrapper<dynamic>?> buyerLoginWithSocialMedia(
      SupplierSocialLoginParams params);
  Future<ResponseWrapper<dynamic>?> buyerSignIn(SigninParams params);
  Future<ResponseWrapper<dynamic>?> register(RegisterParams params);

  Future<ResponseWrapper<dynamic>?> forgotpasswordsendotp(
      ForgotPasswordSendOtpParams params);
  Future<ResponseWrapper<dynamic>?> sendOtp(SendOtpParams params);
  Future<ResponseWrapper<dynamic>?> sendFMCGSellerOtp(SendOtpParams params);
  Future<ResponseWrapper<dynamic>?> sendFMCGBuyerOtp(SendOtpParams params);

  Future<ResponseWrapper<dynamic>?> verifyOtp(VerifyOtpParams params);
  Future<ResponseWrapper<dynamic>?> verifyOtpFMCGSeller(VerifyOtpParams params);
  Future<ResponseWrapper<dynamic>?> verifyOtpFMCGBuyer(VerifyOtpParams params);

  Future<ResponseWrapper<dynamic>?> sendOtpBuyer(SendOtpParams params);
  Future<ResponseWrapper<dynamic>?> verifyOtpBuyer(VerifyOtpParams params);
  Future<ResponseWrapper<dynamic>?> signOut(NoParams params);
  Future<ResponseWrapper<dynamic>?> deleteAccount(DeleteAccountParams params);
  Future<ResponseWrapper<dynamic>?> getCountryCodeList(NoParams params);
  Future<ResponseWrapper<dynamic>?> fmcgSellerSignIn(
      FmcgSellerSigninParams params);
  Future<ResponseWrapper<dynamic>?> fmcgBuyerSignIn(
      FmcgSellerSigninParams params);
  Future<ResponseWrapper<dynamic>?> fmcgBuyerLoginWithSocialMedia(
      SupplierSocialLoginParams params);
  Future<ResponseWrapper<dynamic>?> fmcgSellerLoginWithSocialMedia(
      SupplierSocialLoginParams params);
  Future<ResponseWrapper<dynamic>?> fmcgRegisterSeller(
      FmcgRegisterSellerParams params);
  Future<ResponseWrapper<dynamic>?> fmcgRegisterDistributor(
      FmcgRegisterDistributorParams params);
  Future<ResponseWrapper<dynamic>?> fmcgGetCountryCodeList(NoParams params);
  Future<ResponseWrapper<dynamic>?> fmcgBrandsList(NoParams params);

  Future<ResponseWrapper<dynamic>?> fmcgBuyerCategoryList(NoParams params);
  Future<ResponseWrapper<dynamic>?> fmcgBuyerBrandPartnershipList(
      NoParams params);
  Future<ResponseWrapper<dynamic>?> fmcgBuyerDistributionCoverageList(
      NoParams params);
  Future<ResponseWrapper<dynamic>?> fmcgSellerBusinessTypeList(NoParams params);
  Future<ResponseWrapper<dynamic>?> fmcgSellerProductCategoryList(
      NoParams params);
  Future<ResponseWrapper<dynamic>?> fmcgSellerPartnershipTypeList(
      NoParams params);
  Future<ResponseWrapper<dynamic>?> fmcgSellerServiceLabelList(NoParams params);
  Future<ResponseWrapper<dynamic>?> fmcgSellerExportingProductsList(
      NoParams params);
}

class AuthenticationRemoteDataSourceImpl
    implements AuthenticationRemoteDataSource {
  ApiConsumer apiConsumer;

  AuthenticationRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ResponseWrapper<dynamic>?> adminLogin(AdminLoginParams params) async {
    return await apiConsumer.post(
      EndPoints.adminLogin,
      body: params.toJson(),
    );
  }


  @override
  Future<ResponseWrapper<dynamic>?> adminLogout(NoParams params) async {
    final storage = SecureStorageService();
    final token =
        await storage.read(AppStrings.apiVerificationCode) ?? Constants.token;
    final loginIdStr = await storage.read(AppStrings.loginId) ?? '';
    final loginId = int.tryParse(loginIdStr);
    final deviceId = Constants.deviceID.isNotEmpty
        ? Constants.deviceID
        : await storage.read(AppStrings.deviceId) ?? '';

    return await apiConsumer.post(
      EndPoints.adminLogout,
      body: {
        'Token': token,
        'LoginID': loginId,
        'DeviceID': deviceId,
      },
    );
  }









  @override
  Future<ResponseWrapper<dynamic>?> signIn(SigninParams params) async {
    return await apiConsumer.post(
      EndPoints.signIn(UserType.supplier),
      body: await params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> supplierLoginWithSocialMedia(
      SupplierSocialLoginParams params) async {
    return await apiConsumer.post(
      EndPoints.supplierLoginWithSocialMedia,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> buyerLoginWithSocialMedia(
      SupplierSocialLoginParams params) async {
    return await apiConsumer.post(
      EndPoints.buyerLoginWithSocialMedia,
      body: params.toJson(),
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
  Future<ResponseWrapper<dynamic>?> verifyOtp(VerifyOtpParams params) async {
    return await apiConsumer.post(
      EndPoints.verifyOtp(UserType.supplier),
      body: params.toJson(),
    );
  }

/*

  @override
  Future<ResponseWrapper<dynamic>?> verifyOtpFMCGSeller(VerifyOtpParams params) async {
    return await apiConsumer.post(
      EndPoints.verifyOtpFMCGSeller(UserType.FMCG),
      body: params.toJson(),
    );
  }
*/

  @override
  Future<ResponseWrapper<dynamic>?> verifyOtpFMCGSeller(VerifyOtpParams params) async {
    return await apiConsumer.post(
      EndPoints.verifyOtpFMCGSeller(UserType.FMCG),
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> verifyOtpFMCGBuyer(
      VerifyOtpParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgVerifyBuyerOtpForLogin,
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
    var params = {
      "Token": await storage.read(AppStrings.apiVerificationCode),
      "DeviceID": await storage.read(AppStrings.deviceId)
    };
    return await apiConsumer.post(
      Constants.isFmcg == true
          ? Constants.isBuyer == true
              ? EndPoints.fmcgSignout(UserType.buyer)
              : EndPoints.fmcgSignout(UserType.supplier)
          : Constants.isBuyer == true
              ? EndPoints.signOut(UserType.buyer)
              : EndPoints.signOut(UserType.supplier),
      body: Constants.isFmcg == true ? params : dparams.toJson(),
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

  @override
  Future<ResponseWrapper<dynamic>?> getCountryCodeList(NoParams params) async {
    return await apiConsumer.post(
      EndPoints.countryCodeList,
      body: {"Token": "2018APR031848"},
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgSellerSignIn(
      FmcgSellerSigninParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgSellerSignin,
      body: await params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgBuyerSignIn(
      FmcgSellerSigninParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgBuyerSignin,
      body: await params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgBuyerLoginWithSocialMedia(
      SupplierSocialLoginParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgBuyerLoginWithSocialMedia,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgSellerLoginWithSocialMedia(
      SupplierSocialLoginParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgSellerLoginWithSocialMedia,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgRegisterSeller(
      FmcgRegisterSellerParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgRegisterSeller,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgRegisterDistributor(
      FmcgRegisterDistributorParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgRegisterDistributor,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgGetCountryCodeList(
      NoParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgCountryCodeList,
      body: {"Token": ""},
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgBrandsList(NoParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgGetAllBrandList,
      body: {"Token": ""},
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgBuyerCategoryList(
      NoParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgBuyerCategoryList,
      body: null,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgBuyerBrandPartnershipList(
      NoParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgBuyerBrandPartnershipList,
      body: null,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgBuyerDistributionCoverageList(
      NoParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgBuyerDistributionCoverageList,
      body: null,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgSellerBusinessTypeList(
      NoParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgSellerBusinessTypeList,
      body: null,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgSellerProductCategoryList(
      NoParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgSellerProductCategoryList,
      body: null,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgSellerPartnershipTypeList(
      NoParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgSellerPartnershipTypeList,
      body: null,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgSellerServiceLabelList(
      NoParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgSellerServiceLabelList,
      body: null,
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> fmcgSellerExportingProductsList(
      NoParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgSellerExportingProductsList,
      body: null,
    );
  }





  @override
  Future<ResponseWrapper<dynamic>?> forgotpasswordsendotp(
      ForgotPasswordSendOtpParams params) async {
    return await apiConsumer.postSupplierResult(
      EndPoints.forgotpasswordsendotp,
      body: params.toJson(),
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
  Future<ResponseWrapper<dynamic>?> sendFMCGSellerOtp(SendOtpParams params) async {
    return await apiConsumer.post(
      EndPoints.sendSellerOTPForLogin(UserType.FMCG),
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> sendFMCGBuyerOtp(SendOtpParams params) async {
    return await apiConsumer.post(
      EndPoints.fmcgSendBuyerOtpForLogin,
      body: params.toJson(),
    );
  }


}
