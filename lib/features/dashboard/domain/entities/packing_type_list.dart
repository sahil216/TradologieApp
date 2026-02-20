import 'package:equatable/equatable.dart';

class PackingTypeList extends Equatable {
  final int? packingTypeId;
  final String? packingValue;

  const PackingTypeList({
    this.packingTypeId,
    this.packingValue,
  });

  @override
  List<Object?> get props => [packingTypeId, packingValue];
}
