import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';

class CommodityListModel extends CommodityList {
  const CommodityListModel({
    super.groupId,
    super.groupName,
  });

  factory CommodityListModel.fromJson(Map<String, dynamic> json) =>
      CommodityListModel(
        groupId: json["GroupID"].toString(),
        groupName: json["GroupName"],
      );
}
