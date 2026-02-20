import 'package:tradologie_app/features/dashboard/domain/entities/packing_type_list.dart';

class PackingTypeListModel extends PackingTypeList {
  const PackingTypeListModel({
    super.packingTypeId,
    super.packingValue,
  });

  factory PackingTypeListModel.fromJson(Map<String, dynamic> json) =>
      PackingTypeListModel(
        packingTypeId: json["PackingTypeID"],
        packingValue: json["PackingValue"],
      );
}
