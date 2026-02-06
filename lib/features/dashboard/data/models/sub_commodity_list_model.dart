import 'package:tradologie_app/features/dashboard/domain/entities/sub_commodity_list.dart';

class SubCommodityListModel extends SubCommodityList {
  const SubCommodityListModel({
    super.categoryId,
    super.categoryName,
  });

  factory SubCommodityListModel.fromJson(Map<String, dynamic> json) =>
      SubCommodityListModel(
        categoryId: json["CategoryID"].toString(),
        categoryName: json["CategoryName"],
      );
}
