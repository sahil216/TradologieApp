import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_partnership_type_list.dart';

class FmcgSellerPartnershipTypeListModel extends FmcgSellerPartnershipTypeList {
  const FmcgSellerPartnershipTypeListModel({
    super.typeId,
    super.name,
    super.insertedDate,
  });

  factory FmcgSellerPartnershipTypeListModel.fromJson(
          Map<String, dynamic> json) =>
      FmcgSellerPartnershipTypeListModel(
        typeId: json["TypeID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );
}
