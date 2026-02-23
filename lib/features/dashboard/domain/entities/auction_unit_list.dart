import 'package:equatable/equatable.dart';

class AuctionUnitList extends Equatable {
  final String? unitName;
  final String? showInRequirement;

  const AuctionUnitList({
    this.unitName,
    this.showInRequirement,
  });

  @override
  List<Object?> get props => [unitName, showInRequirement];
}
