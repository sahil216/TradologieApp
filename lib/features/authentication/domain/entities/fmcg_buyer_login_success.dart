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
  final String? webType;
  final String? fMCGCategory;
  final String? brandPartnershipType;
  final String? distributionCoverage;
  final String? fMCGDistributor;
  final String? partnerBrand;
  final String? specifyRequirement;
  final String? distributionExperience;
  final String? salesTeam;
  final String? warehousingFacility;

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
    this.webType,
    this.fMCGCategory,
    this.brandPartnershipType,
    this.distributionCoverage,
    this.fMCGDistributor,
    this.partnerBrand,
    this.specifyRequirement,
    this.distributionExperience,
    this.salesTeam,
    this.warehousingFacility,
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
        webType,
        fMCGCategory,
        brandPartnershipType,
        distributionCoverage,
        fMCGDistributor,
        partnerBrand,
        specifyRequirement,
        distributionExperience,
        salesTeam,
        warehousingFacility,
      ];
}
