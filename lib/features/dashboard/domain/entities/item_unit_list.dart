import 'package:equatable/equatable.dart';

class ItemUnitList extends Equatable {
  final String? unitName;

  const ItemUnitList({
    this.unitName,
  });

  @override
  List<Object?> get props => [unitName];
}
