import 'package:equatable/equatable.dart';

class FmcgSellerPartnershipTypeList extends Equatable {
  final int? typeId;
  final String? name;
  final String? insertedDate;

  const FmcgSellerPartnershipTypeList({
    this.typeId,
    this.name,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [typeId, name, insertedDate];
}
