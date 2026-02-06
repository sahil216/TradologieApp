import 'package:equatable/equatable.dart';

class SubCommodityList extends Equatable {
  final String? categoryId;
  final String? categoryName;

  const SubCommodityList({
    this.categoryId,
    this.categoryName,
  });

  @override
  List<Object?> get props => [categoryId, categoryName];
}
