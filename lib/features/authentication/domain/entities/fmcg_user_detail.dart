import 'package:equatable/equatable.dart';

class FmcgUserDetail extends Equatable {
  final String? loginId;
  final String? userId;
  final String? accountType;
  final String? titleId;
  final String? titleName;
  final String? fullName;
  final String? genderId;
  final String? genderName;
  final String? mobile;
  final String? email;
  final String? dob;
  final String? apiVerificationCode;
  final String? brandId;
  final String? fromDate;
  final String? toDate;
  final String? analyticsUrl;
  final String? countryCode;
  final String? businessType;
  final String? productCategory;
  final String? partnershipType;
  final String? serviceLabel;
  final String? exportingProducts;
  final String? countryID;
  final String? brandName;

  const FmcgUserDetail(
      {this.loginId,
      this.userId,
      this.accountType,
      this.titleId,
      this.titleName,
      this.fullName,
      this.genderId,
      this.genderName,
      this.mobile,
      this.email,
      this.dob,
      this.apiVerificationCode,
      this.brandId,
      this.fromDate,
      this.toDate,
      this.analyticsUrl,
      this.countryCode,
      this.businessType,
      this.productCategory,
      this.partnershipType,
      this.serviceLabel,
      this.exportingProducts,
      this.countryID,
      this.brandName});

  @override
  List<Object?> get props => [
        loginId,
        userId,
        accountType,
        titleId,
        titleName,
        fullName,
        genderId,
        genderName,
        mobile,
        email,
        dob,
        apiVerificationCode,
        brandId,
        fromDate,
        toDate,
        analyticsUrl,
        countryCode,
        businessType,
        productCategory,
        partnershipType,
        serviceLabel,
        exportingProducts,
        countryID,
        brandName
      ];
}
