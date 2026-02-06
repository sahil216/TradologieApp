import 'package:equatable/equatable.dart';

class VerifyOtpResult extends Equatable {
  final int? vendorId;
  final String? vendorName;
  final int? customerId;
  final String? customerName;
  final String? userId;
  final String? apiVerificationCode;
  final String? imageExist;
  final String? sellerTimeZone;
  final String? mobileNo;
  final String? registrationStatus;

  const VerifyOtpResult({
    this.vendorId,
    this.vendorName,
    this.customerId,
    this.customerName,
    this.userId,
    this.apiVerificationCode,
    this.imageExist,
    this.sellerTimeZone,
    this.mobileNo,
    this.registrationStatus,
  });

  @override
  List<Object?> get props => [
        vendorId,
        vendorName,
        customerId,
        customerName,
        userId,
        apiVerificationCode,
        imageExist,
        sellerTimeZone,
        mobileNo,
        registrationStatus,
      ];
}
