import 'package:equatable/equatable.dart';

import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_item_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class AuctionItemListUsecase
    implements UseCase<List<AuctionItemListData>, AuctionItemListParams> {
  final AddNegotiationRepository addNegotiationRepository;

  AuctionItemListUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, List<AuctionItemListData>>> call(
          AuctionItemListParams params) =>
      addNegotiationRepository.auctionItemList(params);
}

class AuctionItemListParams extends Equatable {
  final String token;
  final String auctionID;

  const AuctionItemListParams({
    required this.token,
    required this.auctionID,
  });

  @override
  List<Object?> get props => [token, auctionID];

  Map<String, dynamic> toJson() {
    return {"Token": token, "AuctionID": auctionID};
  }
}
