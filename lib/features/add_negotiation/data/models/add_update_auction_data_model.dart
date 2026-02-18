import 'package:tradologie_app/features/add_negotiation/domian/enitities/add_update_auction_data.dart';

class AddUpdateAuctionDataModel extends AddUpdateAuctionData {
  const AddUpdateAuctionDataModel({
    super.auctionId,
  });

  factory AddUpdateAuctionDataModel.fromJson(Map<String, dynamic> json) =>
      AddUpdateAuctionDataModel(
        auctionId: json["AuctionID"],
      );
}
