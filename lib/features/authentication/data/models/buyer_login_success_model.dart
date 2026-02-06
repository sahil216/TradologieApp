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

  factory BuyerLoginSuccessModel.fromJson(Map<String, dynamic> json) =>
      BuyerLoginSuccessModel(
        customerId: json["CustomerID"].toString(),
        fullName: json["FullName"],
        userId: json["UserID"],
        apiVerificationCode: json["APIVerificationCode"],
        userTimeZone: json["UserTimeZone"],
        companyName: json["CompanyName"],
        dob: json["DOB"],
        gender: json["Gender"],
        mobileNo: json["mobileNo"],
        businessNo: json["BusinessNo"],
        email: json["Email"],
        registrationStatus: json["RegistrationStatus"],
        verificationStatus: json["VerificationStatus"].toString(),
        isComplete: json["IsComplete"],
      );
}
