import 'package:equatable/equatable.dart';

class AuctionItemListData extends Equatable {
  final int? quantity;
  final String? unit;
  final int? auctionTranId;
  final int? groupId;
  final String? groupName;
  final String? packingSize;
  final String? packingType;
  final String? packingImage;
  final String? categoryName;
  final String? customCategory;
  final String? attributeValue1;
  final String? attributeValue2;

  const AuctionItemListData({
    this.quantity,
    this.unit,
    this.auctionTranId,
    this.groupId,
    this.groupName,
    this.packingSize,
    this.packingType,
    this.packingImage,
    this.categoryName,
    this.customCategory,
    this.attributeValue1,
    this.attributeValue2,
  });

  @override
  List<Object?> get props => [
        quantity,
        unit,
        auctionTranId,
        groupId,
        groupName,
        packingSize,
        packingType,
        packingImage,
        categoryName,
        customCategory,
        attributeValue1,
        attributeValue2,
      ];
}
