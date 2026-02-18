import 'package:equatable/equatable.dart';

import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_detail_for_edit_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class AuctionDetailForEditUsecase
    implements UseCase<AuctionDetailForEditData, AuctionDetailForEditParams> {
  final AddNegotiationRepository addNegotiationRepository;

  AuctionDetailForEditUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, AuctionDetailForEditData>> call(
          AuctionDetailForEditParams params) =>
      addNegotiationRepository.auctionDetailForEdit(params);
}

class AuctionDetailForEditParams extends Equatable {
  final String token;
  final String auctionID;
  final String userTimeZone;

  const AuctionDetailForEditParams({
    required this.token,
    required this.auctionID,
    required this.userTimeZone,
  });

  @override
  List<Object?> get props => [token, auctionID, userTimeZone];

  Map<String, dynamic> toJson() {
    return {
      "Token": token,
      "AuctionID": auctionID,
      "UserTimeZone": userTimeZone
    };
  }
}
