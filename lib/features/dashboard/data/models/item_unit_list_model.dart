import 'package:tradologie_app/features/dashboard/domain/entities/item_unit_list.dart';

class ItemUnitListModel extends ItemUnitList {
  const ItemUnitListModel({
    super.unitName,
  });

  factory ItemUnitListModel.fromJson(Map<String, dynamic> json) =>
      ItemUnitListModel(
        unitName: json["UnitName"],
      );
}
