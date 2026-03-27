import 'package:equatable/equatable.dart';

class FmcgSellerBusinessTypeList extends Equatable {
  final int? typeId;
  final String? name;
  final String? insertedDate;

  const FmcgSellerBusinessTypeList({
    this.typeId,
    this.name,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [typeId, name, insertedDate];
}
