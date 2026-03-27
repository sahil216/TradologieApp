import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_buyer_brands_list.dart';

class FmcgBuyerBrandsListModel extends FmcgBuyerBrandsList {
  const FmcgBuyerBrandsListModel({
    super.brandId,
    super.brandName,
    super.brandNameUrl,
    super.localInternalPath,
    super.brandImage,
    super.brandAltText,
    super.insertedDate,
    super.updatedDate,
    super.analyticsUrl,
    super.totalInterestedDistributors,
    super.isInterested,
  });

  factory FmcgBuyerBrandsListModel.fromJson(Map<String, dynamic> json) =>
      FmcgBuyerBrandsListModel(
        brandId: json["BrandID"],
        brandName: json["BrandName"],
        brandNameUrl: json["BrandNameURL"],
        localInternalPath: json["LocalInternalPath"],
        brandImage: json["BrandImage"],
        brandAltText: json["BrandAltText"],
        insertedDate: json["InsertedDate"],
        updatedDate: json["UpdatedDate"],
        analyticsUrl: json["Analytics_URL"],
        totalInterestedDistributors: json["TotalInterestedDistributors"],
        isInterested: json["IsInterested"],
      );
}
