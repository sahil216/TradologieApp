import 'package:tradologie_app/features/dashboard/domain/entities/attribute_list.dart';

class AttributeListModel extends AttributeList {
  const AttributeListModel({
    super.attributeValueId,
    super.attributeValue,
  });

  factory AttributeListModel.fromJson(Map<String, dynamic> json) =>
      AttributeListModel(
        attributeValueId: json["AttributeValueID"].toString(),
        attributeValue: json["AttributeValue"],
      );
}
