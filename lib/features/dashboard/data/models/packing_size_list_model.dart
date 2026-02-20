import 'package:tradologie_app/features/dashboard/domain/entities/packing_size_list.dart';

class PackingSizeListModel extends PackingSizeList {
  PackingSizeListModel({
    super.packingSizeId,
    super.packingSizeValue,
  });

  factory PackingSizeListModel.fromJson(Map<String, dynamic> json) =>
      PackingSizeListModel(
        packingSizeId: json["PackingSizeID"],
        packingSizeValue: json["PackingSizeValue"],
      );
}
