import 'package:equatable/equatable.dart';

class PackingSizeList extends Equatable {
  final int? packingSizeId;
  final String? packingSizeValue;

  const PackingSizeList({
    this.packingSizeId,
    this.packingSizeValue,
  });
  @override
  List<Object?> get props => [packingSizeId, packingSizeValue];
}
