import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_list_item.dart';

class FmcgQuotationListItemModel extends FmcgQuotationListItem {
  const FmcgQuotationListItemModel({
    required super.rowNum,
    required super.quotationId,
    required super.buyerName,
    required super.buyerMobile,
    required super.buyerEmail,
    required super.quotationNo,
    required super.quotationDate,
    required super.quotationStatusId,
    required super.quotationStatusName,
    required super.brandName,
  });

  factory FmcgQuotationListItemModel.fromJson(Map<String, dynamic> json) =>
      FmcgQuotationListItemModel(
        rowNum: _toInt(json['RowNum']),
        quotationId: _toInt(json['QuotationId']),
        buyerName: json['BuyerName']?.toString() ?? '',
        buyerMobile: json['BuyerMobile']?.toString() ?? '',
        buyerEmail: json['BuyerEmail']?.toString() ?? '',
        quotationNo: json['QuotationNo']?.toString() ?? '',
        quotationDate: json['QuotationDate']?.toString() ?? '',
        quotationStatusId: json['QuotationStatusID']?.toString() ?? '',
        quotationStatusName: json['QuotationstatusName']?.toString() ?? '',
        brandName: json['BrandName']?.toString() ?? '',
      );

  static int _toInt(dynamic v) {
    if (v is int) return v;
    if (v is String) return int.tryParse(v) ?? 0;
    return 0;
  }
}
