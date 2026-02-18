import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_item_list_data.dart';

class AuctionItemListDataModel extends AuctionItemListData {
  const AuctionItemListDataModel({
    super.quantity,
    super.unit,
    super.auctionTranId,
    super.groupId,
    super.groupName,
    super.packingSize,
    super.packingType,
    super.packingImage,
    super.categoryName,
    super.customCategory,
    super.attributeValue1,
    super.attributeValue2,
  });

  factory AuctionItemListDataModel.fromJson(Map<String, dynamic> json) =>
      AuctionItemListDataModel(
        quantity: json["Quantity"],
        unit: json["Unit"],
        auctionTranId: json["AuctionTranID"],
        groupId: json["GroupID"],
        groupName: json["GroupName"],
        packingSize: json["PackingSize"],
        packingType: json["PackingType"],
        packingImage: json["PackingImage"],
        categoryName: json["CategoryName"],
        customCategory: json["CustomCategory"],
        attributeValue1: json["AttributeValue1"],
        attributeValue2: json["AttributeValue2"],
      );
}
