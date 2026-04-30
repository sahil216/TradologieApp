import 'package:equatable/equatable.dart';

class FMCGSellerUserDetail extends Equatable {
  final int? loginId;
  final String? userId;
  final String? accountType;
  final int? titleId;
  final String? titleName;
  final String? fullName;
  final int? genderId;
  final String? genderName;
  final int? countryId;
  final String? countryCode;
  final String? mobile;
  final String? email;
  final String? dob;
  final String? apiVerificationCode;
  final String? fromDate;
  final String? toDate;
  final int? brandId;
  final int? enquiryId;
  final String? brandName;
  final String? analyticsUrl;
  final String? businessType;
  final String? productCategory;
  final String? partnershipType;
  final String? serviceLabel;
  final String? exportingProducts;

  const FMCGSellerUserDetail({
    this.loginId,
    this.userId,
    this.accountType,
    this.titleId,
    this.titleName,
    this.fullName,
    this.genderId,
    this.genderName,
    this.countryId,
    this.countryCode,
    this.mobile,
    this.email,
    this.dob,
    this.apiVerificationCode,
    this.fromDate,
    this.toDate,
    this.brandId,
    this.enquiryId,
    this.brandName,
    this.analyticsUrl,
    this.businessType,
    this.productCategory,
    this.partnershipType,
    this.serviceLabel,
    this.exportingProducts,
  });

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
    countryId,
    countryCode,
    mobile,
    email,
    dob,
    apiVerificationCode,
    fromDate,
    toDate,
    brandId,
    enquiryId,
    brandName,
    analyticsUrl,
    businessType,
    productCategory,
    partnershipType,
    serviceLabel,
    exportingProducts,
  ];
}