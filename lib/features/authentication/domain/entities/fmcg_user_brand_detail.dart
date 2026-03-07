import 'package:equatable/equatable.dart';

class FmcgUserBrandDetail extends Equatable {
  final int? linkId;
  final int? loginId;
  final int? brandId;
  final String? brandName;
  final DateTime? insertedDate;

  const FmcgUserBrandDetail({
    this.linkId,
    this.loginId,
    this.brandId,
    this.brandName,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [
        linkId,
        loginId,
        brandId,
        brandName,
        insertedDate,
      ];
}
