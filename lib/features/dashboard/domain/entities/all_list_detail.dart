import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/attribute_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/item_unit_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/sub_commodity_list.dart';

class AllListDetail extends Equatable {
  final List<SubCommodityList>? categoryList;
  final String? attribute1Header;
  final List<AttributeList>? attribute1List;
  final String? attribute2Header;
  final List<AttributeList>? attribute2List;
  final List<ItemUnitList>? itemUnitList;

  const AllListDetail({
    this.categoryList,
    this.attribute1Header,
    this.attribute1List,
    this.attribute2Header,
    this.attribute2List,
    this.itemUnitList,
  });

  @override
  List<Object?> get props => [
        categoryList,
        attribute1Header,
        attribute1List,
        attribute2Header,
        attribute2List,
        itemUnitList,
      ];
}
