import 'package:equatable/equatable.dart';

class SendOtpResult extends Equatable {
  final String? mobileNo;
  final String? otp;
  final int? success;
  final String? message;

  const SendOtpResult({
    this.mobileNo,
    this.otp,
    this.success,
    this.message,
  });

  @override
  List<Object?> get props => [mobileNo, otp, success, message];
}
