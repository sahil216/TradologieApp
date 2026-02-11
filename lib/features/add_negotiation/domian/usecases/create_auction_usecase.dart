import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/create_auction_detail.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class CreateAuctionUsecase
    implements UseCase<CreateAuctionDetail, CreateAuctionParams> {
  final AddNegotiationRepository addNegotiationRepository;

  CreateAuctionUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, CreateAuctionDetail>> call(
          CreateAuctionParams params) =>
      addNegotiationRepository.createAuction(params);
}

class CreateAuctionParams extends Equatable {
  final String token;
  final String customerId;
  final String groupID;
  const CreateAuctionParams(
      {required this.customerId, required this.groupID, required this.token});
  @override
  List<Object?> get props => [customerId, groupID, token];

  Map<String, dynamic> toJson() => {
        "Token": token,
        "CustomerID": customerId,
        "GroupID": groupID,
      };
}
