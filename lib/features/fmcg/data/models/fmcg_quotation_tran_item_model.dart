import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_tran_item.dart';

class FmcgQuotationTranItemModel extends FmcgQuotationTranItem {
  const FmcgQuotationTranItemModel({
    required super.quotationTranId,
    required super.quotationId,
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.quotedRate,
    required super.counterOfferRate,
    required super.counterOfferAccepted,
    required super.attributeValue1Id,
    required super.attributeValue2Id,
    required super.attributeValueName1,
    required super.attributeValueName2,
    required super.quotationStatus,
  });

  factory FmcgQuotationTranItemModel.fromJson(Map<String, dynamic> json) =>
      FmcgQuotationTranItemModel(
        quotationTranId: _toInt(json['QuotationTranId']),
        quotationId: _toInt(json['QuotationId']),
        productId: _toInt(json['ProductId']),
        productName: json['ProductName']?.toString() ?? '',
        quantity: json['Quantity']?.toString() ?? '',
        quotedRate: _toDouble(json['QuotedRate']),
        counterOfferRate: _toDouble(json['CounterOfferRate']),
        counterOfferAccepted: json['CounterOfferAccepted']?.toString() ?? '',
        attributeValue1Id: _toInt(json['AttributeValue1Id']),
        attributeValue2Id: _toInt(json['AttributeValue2Id']),
        attributeValueName1: json['AttributeValueName1']?.toString() ?? '',
        attributeValueName2: json['AttributeValueName2']?.toString() ?? '',
        quotationStatus: json['QuotationStatus']?.toString() ?? '',
      );

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic v) {
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is String) return double.tryParse(v) ?? 0.0;
    return 0.0;
  }
}
