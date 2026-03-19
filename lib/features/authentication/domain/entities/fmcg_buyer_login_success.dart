import 'package:equatable/equatable.dart';

class FmcgBuyerLoginSuccess extends Equatable {
  final int? rowNum;
  final int? quotationUserId;
  final String? userId;
  final String? name;
  final String? countryCode;
  final String? mobile;
  final String? email;
  final dynamic password;
  final int? insertedId;
  final String? insertedDate;
  final String? updatedDate;
  final int? updatedId;
  final String? companyName;
  final String? interestedBrandName;
  final String? perferredLocation;
  final int? brandId;
  final String? apiVerificationCode;

  const FmcgBuyerLoginSuccess({
    this.rowNum,
    this.quotationUserId,
    this.userId,
    this.name,
    this.countryCode,
    this.mobile,
    this.email,
    this.password,
    this.insertedId,
    this.insertedDate,
    this.updatedDate,
    this.updatedId,
    this.companyName,
    this.interestedBrandName,
    this.perferredLocation,
    this.brandId,
    this.apiVerificationCode,
  });

  @override
  List<Object?> get props => [
        rowNum,
        quotationUserId,
        userId,
        name,
        countryCode,
        mobile,
        email,
        password,
        insertedId,
        insertedDate,
        updatedDate,
        updatedId,
        companyName,
        interestedBrandName,
        perferredLocation,
        brandId,
        apiVerificationCode,
      ];
}
