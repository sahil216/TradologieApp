import 'package:equatable/equatable.dart';

import 'buyer_negotitation_detail.dart';

class BuyerNegotiation extends Equatable {
  final List<BuyerNegotiationDetail>? detail;
  final int? success;
  final String? message;

  final int? totalRecords;
  final int? totalPages;

  const BuyerNegotiation({
    this.detail,
    this.success,
    this.message,
    this.totalRecords,
    this.totalPages,
  });

  @override
  List<Object?> get props =>
      [detail, success, message, totalRecords, totalPages];
}
