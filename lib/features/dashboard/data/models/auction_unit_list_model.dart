import 'package:tradologie_app/features/dashboard/domain/entities/auction_unit_list.dart';

class AuctionUnitListModel extends AuctionUnitList {
  const AuctionUnitListModel({
    super.unitName,
    super.showInRequirement,
  });

  factory AuctionUnitListModel.fromJson(Map<String, dynamic> json) =>
      AuctionUnitListModel(
        unitName: json["UnitName"],
        showInRequirement: json["ShowInRequirement"],
      );
}
