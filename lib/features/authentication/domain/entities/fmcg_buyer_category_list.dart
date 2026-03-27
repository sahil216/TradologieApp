import 'package:equatable/equatable.dart';

class FmcgBuyerCategoryList extends Equatable {
  final int? categoryId;
  final String? name;
  final String? insertedDate;

  const FmcgBuyerCategoryList({
    this.categoryId,
    this.name,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [categoryId, name, insertedDate];
}
