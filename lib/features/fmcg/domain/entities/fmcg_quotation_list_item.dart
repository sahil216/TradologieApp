import 'package:equatable/equatable.dart';

class FmcgQuotationListItem extends Equatable {
  final int rowNum;
  final int quotationId;
  final String buyerName;
  final String buyerMobile;
  final String buyerEmail;
  final String quotationNo;
  final String quotationDate;
  final String quotationStatusId;
  final String quotationStatusName;
  final String brandName;

  const FmcgQuotationListItem({
    required this.rowNum,
    required this.quotationId,
    required this.buyerName,
    required this.buyerMobile,
    required this.buyerEmail,
    required this.quotationNo,
    required this.quotationDate,
    required this.quotationStatusId,
    required this.quotationStatusName,
    required this.brandName,
  });

  @override
  List<Object?> get props => [
        rowNum,
        quotationId,
        buyerName,
        buyerMobile,
        buyerEmail,
        quotationNo,
        quotationDate,
        quotationStatusId,
        quotationStatusName,
        brandName,
      ];
}

class FmcgQuotationListResult extends Equatable {
  final List<FmcgQuotationListItem> items;
  final int totalPages;
  final int totalRecords;

  const FmcgQuotationListResult({
    required this.items,
    required this.totalPages,
    required this.totalRecords,
  });

  @override
  List<Object?> get props => [items, totalPages, totalRecords];
}
