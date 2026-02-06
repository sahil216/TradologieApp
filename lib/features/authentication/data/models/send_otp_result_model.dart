import '../../domain/entities/send_otp_result.dart';

class SendOtpResultModel extends SendOtpResult {
  const SendOtpResultModel({
    super.mobileNo,
    super.otp,
    super.success,
    super.message,
  });

  factory SendOtpResultModel.fromJson(Map<String, dynamic> json) =>
      SendOtpResultModel(
        mobileNo: json["MobileNo"],
        otp: json["OTP"],
        success: json["success"],
        message: json["message"],
      );
}
