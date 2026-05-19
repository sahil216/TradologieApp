import 'package:equatable/equatable.dart';

class ForgotpasswordsendotpSuccess extends Equatable {
  final int? vendorId;
  final int? success;
  final String? message;

  const ForgotpasswordsendotpSuccess({
    this.vendorId,
    this.success,
    this.message,

  });

  @override
  List<Object?> get props => [
    vendorId,
    success,
    message,

  ];
}
