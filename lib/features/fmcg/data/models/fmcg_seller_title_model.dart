import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_title.dart';

class FmcgSellerTitleModel extends FmcgSellerTitle {
  const FmcgSellerTitleModel({
    super.titleId,
    super.titleName,
  });

  factory FmcgSellerTitleModel.fromJson(Map<String, dynamic> json) =>
      FmcgSellerTitleModel(
        titleId: json["TitleID"],
        titleName: json["TitleName"],
      );
}
