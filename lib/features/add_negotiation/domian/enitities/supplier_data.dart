import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_list.dart';

class GetSupplierData extends Equatable {
  final List<SupplierList>? detail;
  final int? success;
  final String? message;
  final int? totalRecords;
  final int? totalPages;

  const GetSupplierData({
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
