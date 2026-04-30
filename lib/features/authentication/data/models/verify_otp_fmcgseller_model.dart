import '../../domain/entities/verify_otp_fmcg_seller.dart';

class FMCGSellerVerifyOtpModel extends FMCGSellerUserDetail {
  const FMCGSellerVerifyOtpModel({
    super.loginId,
    super.userId,
    super.accountType,
    super.titleId,
    super.titleName,
    super.fullName,
    super.genderId,
    super.genderName,
    super.countryId,
    super.countryCode,
    super.mobile,
    super.email,
    super.dob,
    super.apiVerificationCode,
    super.fromDate,
    super.toDate,
    super.brandId,
    super.enquiryId,
    super.brandName,
    super.analyticsUrl,
    super.businessType,
    super.productCategory,
    super.partnershipType,
    super.serviceLabel,
    super.exportingProducts,
  });

  factory FMCGSellerVerifyOtpModel.fromJson(Map<String, dynamic> json) =>
      // FMCG verify OTP returns payload under "FMCGUserDetail".
      // Fallback to root json to keep backward compatibility.
      FMCGSellerVerifyOtpModel._fromDetail(
        (json["FMCGUserDetail"] as Map<String, dynamic>?) ?? json,
      );

  factory FMCGSellerVerifyOtpModel._fromDetail(Map<String, dynamic> json) =>
      FMCGSellerVerifyOtpModel(
        loginId: json["LoginID"],
        userId: json["UserID"],
        accountType: json["AccountType"],
        titleId: json["TitleID"],
        titleName: json["TitleName"],
        fullName: json["FullName"],
        genderId: json["GenderID"],
        genderName: json["GenderName"],
        countryId: json["CountryID"],
        countryCode: json["CountryCode"],
        mobile: json["Mobile"],
        email: json["Email"],
        dob: json["DOB"],
        apiVerificationCode: json["ApiVerificationCode"],
        fromDate: json["FromDate"],
        toDate: json["ToDate"],
        brandId: json["BrandID"],
        enquiryId: json["EnquiryID"],
        brandName: json["BrandName"],
        analyticsUrl: json["Analytics_URL"],
        businessType: json["BusinessType"],
        productCategory: json["ProductCategory"],
        partnershipType: json["PartnershipType"],
        serviceLabel: json["ServiceLabel"],
        exportingProducts: json["ExportingProducts"],
      );
}