import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';

class DistributorEnquiryListModel extends DistributorEnquiryList {
  const DistributorEnquiryListModel({
    super.quotationUserId,
    super.userId,
    super.name,
    super.countryCode,
    super.mobile,
    super.email,
    super.insertedId,
    super.companyName,
    super.interestedBrandName,
    super.perferredLocation,
    super.brandId,
    super.insertedDate,
    super.updatedId,
    super.updatedDate,
    super.isInterest,
    super.fMCGCategory,
    super.brandPartnershipType,
    super.distributionCoverage,
    super.fMCGDistributor,
    super.partnerBrand,
    super.specifyRequirement,
    super.distributionExperience,
    super.salesTeam,
    super.warehousingFacility,
  });

  factory DistributorEnquiryListModel.fromJson(Map<String, dynamic> json) =>
      DistributorEnquiryListModel(
        quotationUserId: json["QuotationUserID"],
        userId: json["UserID"],
        name: json["Name"],
        countryCode: json["CountryCode"],
        mobile: json["Mobile"],
        email: json["Email"],
        insertedId: json["InsertedId"],
        companyName: json["CompanyName"],
        interestedBrandName: json["InterestedBrandName"],
        perferredLocation: json["PerferredLocation"],
        brandId: json["BrandID"],
        insertedDate: json["InsertedDate"] == null
            ? null
            : DateTime.parse(json["InsertedDate"]),
        updatedId: json["UpdatedId"],
        updatedDate: json["UpdatedDate"] == null
            ? null
            : DateTime.parse(json["UpdatedDate"]),
        isInterest: json["IsInterest"],
        fMCGCategory: json["FMCGCategory"],
        brandPartnershipType: json["BrandPartnershipType"],
        distributionCoverage: json["DistributionCoverage"],
        fMCGDistributor: json["FMCGDistributor"],
        partnerBrand: json["PartnerBrand"],
        specifyRequirement: json["SpecifyRequirement"],
        distributionExperience: json["DistributionExperience"],
        salesTeam: json["SalesTeam"],
        warehousingFacility: json["WarehousingFacility"],
      );
}
