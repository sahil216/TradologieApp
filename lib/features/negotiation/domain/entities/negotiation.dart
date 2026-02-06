import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/negotiation_result.dart';

class Negotiation extends Equatable {
  final List<NegotiationResult>? detail;
  final int? success;
  final String? message;
  final int? totalRecords;
  final int? totalPages;

  const Negotiation({
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
