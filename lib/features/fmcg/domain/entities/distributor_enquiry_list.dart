import 'package:equatable/equatable.dart';

class DistributorEnquiryList extends Equatable {
  final int? quotationUserId;
  final String? userId;
  final String? name;
  final String? countryCode;
  final String? mobile;
  final String? email;
  final int? insertedId;
  final String? companyName;
  final String? interestedBrandName;
  final String? perferredLocation;
  final int? brandId;
  final DateTime? insertedDate;
  final int? updatedId;
  final DateTime? updatedDate;
  final bool? isInterest;
  final String? fMCGCategory;
  final String? brandPartnershipType;
  final String? distributionCoverage;
  final String? fMCGDistributor;
  final String? partnerBrand;
  final String? specifyRequirement;
  final String? distributionExperience;
  final String? salesTeam;
  final String? warehousingFacility;

  const DistributorEnquiryList({
    this.quotationUserId,
    this.userId,
    this.name,
    this.countryCode,
    this.mobile,
    this.email,
    this.insertedId,
    this.companyName,
    this.interestedBrandName,
    this.perferredLocation,
    this.brandId,
    this.insertedDate,
    this.updatedId,
    this.updatedDate,
    this.isInterest,
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
        quotationUserId,
        userId,
        name,
        countryCode,
        mobile,
        email,
        insertedId,
        companyName,
        interestedBrandName,
        perferredLocation,
        brandId,
        insertedDate,
        updatedId,
        updatedDate,
        isInterest,
        fMCGCategory,
        brandPartnershipType,
        distributionCoverage,
        fMCGDistributor,
        partnerBrand,
        specifyRequirement,
        distributionExperience,
        salesTeam,
        warehousingFacility
      ];
}
