import '../../domain/entities/ForgotpasswordsendotpSucess.dart';

class ForgotPasswordSendOtpResultModel extends ForgotpasswordsendotpSuccess {
  const ForgotPasswordSendOtpResultModel({
    super.vendorId,
    super.success,
    super.message,
  });

  factory ForgotPasswordSendOtpResultModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordSendOtpResultModel(
        vendorId: json["VendorID"] is int
            ? json["VendorID"] as int
            : int.tryParse(json["VendorID"]?.toString() ?? ''),
        success: json["success"] is int
            ? json["success"] as int
            : int.tryParse(json["success"]?.toString() ?? ''),
        message: json["message"]?.toString(),
      );
}
