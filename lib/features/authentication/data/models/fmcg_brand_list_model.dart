import 'package:tradologie_app/features/authentication/domain/entities/fmcg_brands_list.dart';

class FmcgBrandsListModel extends FmcgBrandsList {
  const FmcgBrandsListModel({
    super.brandId,
    super.brandName,
    super.localInternalPath,
    super.brandNameUrl,
    super.brandAltText,
    super.imageExtension,
    super.catalogUrl,
    super.priceListUrl,
    super.brandDescription,
    super.brandImageExtension,
    super.brandLargeDescription,
    super.brandCompany,
  });

  factory FmcgBrandsListModel.fromJson(Map<String, dynamic> json) =>
      FmcgBrandsListModel(
        brandId: json["BrandID"],
        brandName: json["BrandName"],
        localInternalPath: json["LocalInternalPath"],
        brandNameUrl: json["BrandNameURL"],
        brandAltText: json["BrandAltText"],
        imageExtension: json["ImageExtension"],
        catalogUrl: json["CatalogURL"],
        priceListUrl: json["PriceListURL"],
        brandDescription: json["BrandDescription"],
        brandImageExtension: json["BrandImageExtension"],
        brandLargeDescription: json["BrandLargeDescription"],
        brandCompany: json["BrandCompany"],
      );
}
