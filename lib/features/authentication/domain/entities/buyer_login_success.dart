import 'package:equatable/equatable.dart';

class BuyerLoginSuccess extends Equatable {
  final String? customerId;
  final String? fullName;
  final String? userId;
  final String? apiVerificationCode;
  final String? userTimeZone;
  final String? companyName;
  final String? dob;
  final String? gender;
  final String? mobileNo;
  final String? businessNo;
  final String? email;
  final String? registrationStatus;
  final String? verificationStatus;
  final String? isComplete;

  const BuyerLoginSuccess({
    this.customerId,
    this.fullName,
    this.userId,
    this.apiVerificationCode,
    this.userTimeZone,
    this.companyName,
    this.dob,
    this.gender,
    this.mobileNo,
    this.businessNo,
    this.email,
    this.registrationStatus,
    this.verificationStatus,
    this.isComplete,
  });

  @override
  List<Object?> get props => [
        customerId,
        fullName,
        userId,
        apiVerificationCode,
        userTimeZone,
        companyName,
        dob,
        gender,
        mobileNo,
        businessNo,
        email,
        registrationStatus,
        verificationStatus,
        isComplete,
      ];
}
