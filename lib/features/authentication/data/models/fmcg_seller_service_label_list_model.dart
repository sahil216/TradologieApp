import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_service_label_list.dart';

class FmcgSellerServiceLabelListModel extends FmcgSellerServiceLabelList {
  const FmcgSellerServiceLabelListModel({
    super.labelId,
    super.name,
    super.insertedDate,
  });

  factory FmcgSellerServiceLabelListModel.fromJson(Map<String, dynamic> json) =>
      FmcgSellerServiceLabelListModel(
        labelId: json["LabelID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );
}
