import 'package:tradologie_app/features/fmcg/domain/entities/buyer_quotation_item.dart';

class BuyerQuotationItemModel extends BuyerQuotationItem {
  const BuyerQuotationItemModel({
    required super.quotationId,
    required super.brandId,
    required super.brandName,
    required super.productId,
    required super.productName,
    required super.productImageUrl,
    required super.quantity,
    required super.attributeValue1Id,
    required super.attributeValue2Id,
    required super.productTranId,
    required super.attributeValue1Name,
    required super.attributeValue2Name,
    required super.attributeType1Name,
    required super.attributeType2Name,
    required super.unitId,
    required super.unitName,
    required super.minOrderQuantity,
    required super.insertedDate,
    required super.coverImage,
    required super.productImageType,
  });

  factory BuyerQuotationItemModel.fromJson(Map<String, dynamic> json) {
    return BuyerQuotationItemModel(
      quotationId: _toInt(json['QuotationId']),
      brandId: _toInt(json['BrandId']),
      brandName: json['BrandName']?.toString() ?? '',
      productId: _toInt(json['ProductId']),
      productName: json['ProductName']?.toString() ?? '',
      productImageUrl: json['ProductImageURL']?.toString() ?? '',
      quantity: _toInt(json['Quantity']),
      attributeValue1Id: _toInt(json['AttributeValue1Id']),
      attributeValue2Id: _toInt(json['AttributeValue2Id']),
      productTranId: _toInt(json['ProductTranId']),
      attributeValue1Name: json['AttributeValue1Name']?.toString() ?? '',
      attributeValue2Name: json['AttributeValue2Name']?.toString() ?? '',
      attributeType1Name: json['AttributeType1Name']?.toString() ?? '',
      attributeType2Name: json['AttributeType2Name']?.toString() ?? '',
      unitId: _toInt(json['UnitID']),
      unitName: json['UnitName']?.toString() ?? '',
      minOrderQuantity: _toInt(json['MinOrderQuantity']),
      insertedDate: json['InsertedDate']?.toString() ?? '',
      coverImage: json['CoverImage']?.toString() ?? '',
      productImageType: json['ProductImageType']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.toInt();
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}

