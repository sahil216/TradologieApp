import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_brand_partnership_type_list.dart';

class FmcgBuyerBrandPartnershipTypeListModel
    extends FmcgBuyerBrandPartnershipTypeList {
  const FmcgBuyerBrandPartnershipTypeListModel({
    super.typeId,
    super.name,
    super.insertedDate,
  });

  factory FmcgBuyerBrandPartnershipTypeListModel.fromJson(
          Map<String, dynamic> json) =>
      FmcgBuyerBrandPartnershipTypeListModel(
        typeId: json["TypeID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );
}
