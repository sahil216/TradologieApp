import 'package:equatable/equatable.dart';

class FmcgBuyerBrandPartnershipTypeList extends Equatable {
  final int? typeId;
  final String? name;
  final String? insertedDate;

  const FmcgBuyerBrandPartnershipTypeList({
    this.typeId,
    this.name,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [typeId, name, insertedDate];
}
