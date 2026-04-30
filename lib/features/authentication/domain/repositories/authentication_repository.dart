import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
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
import 'package:tradologie_app/features/authentication/domain/entities/login_success.dart';
import 'package:tradologie_app/features/authentication/domain/entities/send_otp_result.dart';
import 'package:tradologie_app/features/authentication/domain/entities/verify_otp_result.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/delete_account_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_distributor_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_register_seller_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/fmcg_seller_signin_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/send_otp_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/verify_otp_usecase.dart';

import '../../../../core/error/failures.dart';
import '../entities/verify_otp_fmcg_seller.dart';
import '../usecases/register_usecase.dart';
import '../usecases/sign_in_usecase.dart';

abstract class AuthenticationRepository {





  Future<Either<Failure, SendOtpResult>> sendOtpBuyer(SendOtpParams params);
  Future<Either<Failure, VerifyOtpResult>> verifyOtpBuyer(
      VerifyOtpParams params);
  Future<Either<Failure, LoginSuccess?>> signIn(SigninParams params);
  Future<Either<Failure, BuyerLoginSuccess?>> buyerSignIn(SigninParams params);
  Future<Either<Failure, bool>> register(RegisterParams params);
  Future<Either<Failure, bool>> signOut(NoParams params);
  Future<Either<Failure, FmcgSellerSigninResponse>> fmcgSellerSignin(
      FmcgSellerSigninParams params);
  Future<Either<Failure, FmcgBuyerLoginSuccess>> fmcgBuyerSignin(
      FmcgSellerSigninParams params);
  Future<Either<Failure, bool>> deleteAccount(DeleteAccountParams params);
  Future<Either<Failure, List<CountryCodeList>>> getCountryCodeList(
      NoParams params);
  Future<Either<Failure, FmcgBuyerLoginSuccess>> fmcgRegisterDistributor(
      FmcgRegisterDistributorParams params);
  Future<Either<Failure, FmcgSellerSigninResponse>> fmcgRegisterSeller(
      FmcgRegisterSellerParams params);
  Future<Either<Failure, List<FmcgCountryCodeList>>> fmcgGetCountryCodeList(
      NoParams params);
  Future<Either<Failure, List<FmcgBrandsList>>> fmcgBrandsList(NoParams params);

  Future<Either<Failure, List<FmcgBuyerCategoryList>>> fmcgBuyerCategoryList(
      NoParams params);
  Future<Either<Failure, List<FmcgBuyerBrandPartnershipTypeList>>>
      fmcgBuyerBrandPartnershipList(NoParams params);
  Future<Either<Failure, List<FmcgBuyerDistributionCoverageList>>>
      fmcgBuyerDistributionCoverageList(NoParams params);
  Future<Either<Failure, List<FmcgSellerBusinessTypeList>>>
      fmcgSellerBusinessTypeList(NoParams params);
  Future<Either<Failure, List<FmcgSellerProductCategoryList>>>
      fmcgSellerProductCategoryList(NoParams params);
  Future<Either<Failure, List<FmcgSellerPartnershipTypeList>>>
      fmcgSellerPartnershipTypeList(NoParams params);
  Future<Either<Failure, List<FmcgSellerServiceLabelList>>>
      fmcgSellerServiceLabelList(NoParams params);
  Future<Either<Failure, List<FmcgSellerExportingProductsList>>>
      fmcgSellerExportingProductsList(NoParams params);





  Future<Either<Failure, SendOtpResult>> sendOtp(SendOtpParams params);
  Future<Either<Failure, SendOtpResult>> sendOtpFMCGseller(SendOtpParams params);


  Future<Either<Failure, VerifyOtpResult>> verifyOtp(VerifyOtpParams params);
  Future<Either<Failure, FMCGSellerUserDetail>> verifyOtpFMCGSeller(VerifyOtpParams params);


}
