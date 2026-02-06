import 'package:equatable/equatable.dart';

class LoginSuccess extends Equatable {
  final int? vendorId;
  final String? vendorName;
  final String? userId;
  final String? apiVerificationCode;
  final String? imageExist;
  final String? sellerTimeZone;
  final String? mobileNo;
  final String? registrationStatus;

  const LoginSuccess({
    this.vendorId,
    this.vendorName,
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
        userId,
        apiVerificationCode,
        imageExist,
        sellerTimeZone,
        mobileNo,
        registrationStatus
      ];
}
