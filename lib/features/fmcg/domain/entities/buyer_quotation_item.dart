import 'package:equatable/equatable.dart';

class BuyerQuotationItem extends Equatable {
  final int quotationId;
  final int brandId;
  final String brandName;
  final int productId;
  final String productName;
  final String productImageUrl;
  final int quantity;
  final int attributeValue1Id;
  final int attributeValue2Id;
  final int productTranId;
  final String attributeValue1Name;
  final String attributeValue2Name;
  final String attributeType1Name;
  final String attributeType2Name;
  final int unitId;
  final String unitName;
  final int minOrderQuantity;
  final String insertedDate;
  final String coverImage;
  final String productImageType;

  const BuyerQuotationItem({
    required this.quotationId,
    required this.brandId,
    required this.brandName,
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.quantity,
    required this.attributeValue1Id,
    required this.attributeValue2Id,
    required this.productTranId,
    required this.attributeValue1Name,
    required this.attributeValue2Name,
    required this.attributeType1Name,
    required this.attributeType2Name,
    required this.unitId,
    required this.unitName,
    required this.minOrderQuantity,
    required this.insertedDate,
    required this.coverImage,
    required this.productImageType,
  });

  @override
  List<Object?> get props => [
        quotationId,
        brandId,
        brandName,
        productId,
        productName,
        productImageUrl,
        quantity,
        attributeValue1Id,
        attributeValue2Id,
        productTranId,
        attributeValue1Name,
        attributeValue2Name,
        attributeType1Name,
        attributeType2Name,
        unitId,
        unitName,
        minOrderQuantity,
        insertedDate,
        coverImage,
        productImageType,
      ];
}

