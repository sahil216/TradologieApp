import 'package:tradologie_app/features/dashboard/data/models/sub_commodity_list_model.dart';
import 'package:tradologie_app/features/dashboard/data/models/item_unit_list_model.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/all_list_detail.dart';

import 'attribute_list_model.dart';

class AllListDetailModel extends AllListDetail {
  const AllListDetailModel({
    super.categoryList,
    super.attribute1Header,
    super.attribute1List,
    super.attribute2Header,
    super.attribute2List,
    super.itemUnitList,
  });

  factory AllListDetailModel.fromJson(Map<String, dynamic> json) =>
      AllListDetailModel(
        categoryList: json["CategoryList"] == null
            ? []
            : List<SubCommodityListModel>.from(json["CategoryList"]!
                .map((x) => SubCommodityListModel.fromJson(x))),
        attribute1Header: json["Attribute1Header"],
        attribute1List: json["Attribute1List"] == null
            ? []
            : List<AttributeListModel>.from(json["Attribute1List"]!
                .map((x) => AttributeListModel.fromJson(x))),
        attribute2Header: json["Attribute2Header"],
        attribute2List: json["Attribute2List"] == null
            ? []
            : List<AttributeListModel>.from(json["Attribute2List"]!
                .map((x) => AttributeListModel.fromJson(x))),
        itemUnitList: json["ItemUnitList"] == null
            ? []
            : List<ItemUnitListModel>.from(json["ItemUnitList"]!
                .map((x) => ItemUnitListModel.fromJson(x))),
      );
}
