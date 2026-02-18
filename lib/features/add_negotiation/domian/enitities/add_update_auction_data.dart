import 'package:equatable/equatable.dart';

class AddUpdateAuctionData extends Equatable {
  final int? auctionId;

  const AddUpdateAuctionData({
    this.auctionId,
  });

  @override
  List<Object?> get props => [auctionId];
}
