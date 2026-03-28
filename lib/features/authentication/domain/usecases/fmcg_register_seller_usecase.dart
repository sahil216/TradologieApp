import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_signin_response.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgRegisterSellerParams {
  final String token;
  final String brandName;
  final String contactName;
  final String countryCode;
  final String emailId;
  final String mobileNo;
  final String manufacturer;
  final String model;
  final String osVersionRelease;
  final String appVersion;
  final String fcmToken;
  final String osType;
  final String deviceId;
  final String businessType;
  final String productCategory;
  final String partnershipType;
  final String serviceLabel;
  final String exportingProducts;

  FmcgRegisterSellerParams(
      {required this.token,
      required this.brandName,
      required this.contactName,
      required this.countryCode,
      required this.emailId,
      required this.mobileNo,
      required this.manufacturer,
      required this.model,
      required this.osVersionRelease,
      required this.appVersion,
      required this.fcmToken,
      required this.osType,
      required this.deviceId,
      required this.businessType,
      required this.productCategory,
      required this.partnershipType,
      required this.serviceLabel,
      required this.exportingProducts});
  Map<String, dynamic> toJson() => {
        "Token": token,
        "BrandName": brandName,
        "ContactName": contactName,
        "CountryCode": countryCode,
        "EmailId": emailId,
        "MobileNo": mobileNo,
        "Manufacturer": manufacturer,
        "Model": model,
        "OSVersionRelease": osVersionRelease,
        "AppVersion": appVersion,
        "FcmToken": fcmToken,
        "OSType": osType,
        "DeviceID": Constants.deviceID,
        "BusinessType": businessType,
        "ProductCategory": productCategory,
        "PartnershipType": partnershipType,
        "ServiceLabel": serviceLabel,
        "ExportingProducts": exportingProducts,
      };
}

class FmcgRegisterSellerUsecase
    implements UseCase<FmcgSellerSigninResponse, FmcgRegisterSellerParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgRegisterSellerUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, FmcgSellerSigninResponse>> call(
          FmcgRegisterSellerParams params) =>
      authenticationRepository.fmcgRegisterSeller(params);
}
