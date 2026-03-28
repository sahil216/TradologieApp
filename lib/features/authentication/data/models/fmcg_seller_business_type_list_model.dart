import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_business_type_list.dart';

class FmcgSellerBusinessTypeListModel extends FmcgSellerBusinessTypeList {
  const FmcgSellerBusinessTypeListModel({
    super.typeId,
    super.name,
    super.insertedDate,
  });

  factory FmcgSellerBusinessTypeListModel.fromJson(Map<String, dynamic> json) =>
      FmcgSellerBusinessTypeListModel(
        typeId: json["TypeID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );
}
