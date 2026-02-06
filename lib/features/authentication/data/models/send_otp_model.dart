import 'package:tradologie_app/features/authentication/data/models/send_otp_result_model.dart';

import '../../domain/entities/send_otp.dart';

class SendOtpModel extends SendOtp {
  const SendOtpModel({
    super.result,
    super.id,
    super.exception,
    super.status,
    super.isCanceled,
    super.isCompleted,
    super.creationOptions,
    super.asyncState,
    super.isFaulted,
  });

  factory SendOtpModel.fromJson(Map<String, dynamic> json) => SendOtpModel(
        result: json["Result"] == null
            ? null
            : SendOtpResultModel.fromJson(json["Result"]),
        id: json["Id"],
        exception: json["Exception"],
        status: json["Status"],
        isCanceled: json["IsCanceled"],
        isCompleted: json["IsCompleted"],
        creationOptions: json["CreationOptions"],
        asyncState: json["AsyncState"],
        isFaulted: json["IsFaulted"],
      );
}
