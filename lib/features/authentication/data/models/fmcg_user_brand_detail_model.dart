import 'package:tradologie_app/features/authentication/domain/entities/fmcg_user_brand_detail.dart';

class FmcgUserBrandDetailModel extends FmcgUserBrandDetail {
  const FmcgUserBrandDetailModel({
    super.linkId,
    super.loginId,
    super.brandId,
    super.brandName,
    super.insertedDate,
  });

  factory FmcgUserBrandDetailModel.fromJson(Map<String, dynamic> json) =>
      FmcgUserBrandDetailModel(
        linkId: json["LinkID"],
        loginId: json["LoginID"],
        brandId: json["BrandID"],
        brandName: json["BrandName"],
        insertedDate: json["InsertedDate"] == null
            ? null
            : DateTime.parse(json["InsertedDate"]),
      );
}
