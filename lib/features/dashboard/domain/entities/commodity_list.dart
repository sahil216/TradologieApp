import 'package:equatable/equatable.dart';

class CommodityList extends Equatable {
  final String? groupId;
  final String? groupName;

  const CommodityList({
    this.groupId,
    this.groupName,
  });

  @override
  List<Object?> get props => [groupId, groupName];
}
