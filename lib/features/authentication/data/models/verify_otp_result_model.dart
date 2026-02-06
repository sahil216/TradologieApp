import '../../domain/entities/verify_otp_result.dart';

class VerifyOtpResultModel extends VerifyOtpResult {
  const VerifyOtpResultModel({
    super.vendorId,
    super.vendorName,
    super.customerId,
    super.customerName,
    super.userId,
    super.apiVerificationCode,
    super.imageExist,
    super.sellerTimeZone,
    super.mobileNo,
    super.registrationStatus,
  });

  factory VerifyOtpResultModel.fromJson(Map<String, dynamic> json) =>
      VerifyOtpResultModel(
        vendorId: json["VendorID"],
        vendorName: json["VendorName"],
        customerId: json["CustomerID"],
        customerName: json["CustomerName"],
        userId: json["UserID"],
        apiVerificationCode: json["APIVerificationCode"],
        imageExist: json["ImageExist"],
        sellerTimeZone: json["SellerTimeZone"],
        mobileNo: json["MobileNo"],
        registrationStatus: json["RegistrationStatus"],
      );
}
