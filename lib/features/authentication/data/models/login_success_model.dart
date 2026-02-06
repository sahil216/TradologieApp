import 'package:tradologie_app/features/authentication/domain/entities/login_success.dart';

class LoginSuccessModel extends LoginSuccess {
  const LoginSuccessModel({
    super.vendorId,
    super.vendorName,
    super.userId,
    super.apiVerificationCode,
    super.imageExist,
    super.sellerTimeZone,
    super.mobileNo,
    super.registrationStatus,
  });

  factory LoginSuccessModel.fromJson(Map<String, dynamic> json) =>
      LoginSuccessModel(
        vendorId: json["VendorID"],
        vendorName: json["VendorName"],
        userId: json["UserID"],
        apiVerificationCode: json["APIVerificationCode"],
        imageExist: json["ImageExist"],
        sellerTimeZone: json["SellerTimeZone"],
        mobileNo: json["MobileNo"],
        registrationStatus: json["RegistrationStatus"],
      );
}
