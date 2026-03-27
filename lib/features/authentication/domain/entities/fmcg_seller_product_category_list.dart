import 'package:equatable/equatable.dart';

class FmcgSellerProductCategoryList extends Equatable {
  final int? categoryId;
  final String? name;
  final String? insertedDate;

  const FmcgSellerProductCategoryList({
    this.categoryId,
    this.name,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [categoryId, name, insertedDate];
}
