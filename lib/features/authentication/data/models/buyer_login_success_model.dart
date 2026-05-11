import '../../domain/entities/buyer_login_success.dart';

class BuyerLoginSuccessModel extends BuyerLoginSuccess {
  const BuyerLoginSuccessModel({
    super.customerId,
    super.fullName,
    super.userId,
    super.apiVerificationCode,
    super.userTimeZone,
    super.companyName,
    super.dob,
    super.gender,
    super.mobileNo,
    super.businessNo,
    super.email,
    super.registrationStatus,
    super.verificationStatus,
    super.isComplete,
  });

  factory BuyerLoginSuccessModel.fromJson(Map<String, dynamic> json) {
    final fullName =
        json["FullName"]?.toString() ?? json["CustomerName"]?.toString();
    return BuyerLoginSuccessModel(
      customerId: json["CustomerID"]?.toString(),
      fullName: fullName,
      userId: json["UserID"]?.toString(),
      apiVerificationCode: json["APIVerificationCode"]?.toString(),
      userTimeZone:
          json["UserTimeZone"]?.toString() ?? json["SellerTimeZone"]?.toString(),
      companyName: json["CompanyName"]?.toString(),
      dob: json["DOB"]?.toString(),
      gender: json["Gender"]?.toString(),
      mobileNo: json["mobileNo"]?.toString() ?? json["MobileNo"]?.toString(),
      businessNo: json["BusinessNo"]?.toString(),
      email: json["Email"]?.toString(),
      registrationStatus: json["RegistrationStatus"]?.toString(),
      verificationStatus: json["VerificationStatus"]?.toString(),
      isComplete: json["IsComplete"]?.toString(),
    );
  }
}
