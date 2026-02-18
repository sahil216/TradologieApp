import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class DeleteAuctionItemUsecase
    implements UseCase<bool, DeleteAuctionItemParams> {
  final AddNegotiationRepository addNegotiationRepository;

  DeleteAuctionItemUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, bool>> call(DeleteAuctionItemParams params) =>
      addNegotiationRepository.deleteAuctionItem(params);
}

class DeleteAuctionItemParams extends Equatable {
  final String token;
  final String customerID;
  final String auctionTranID;

  const DeleteAuctionItemParams({
    required this.token,
    required this.customerID,
    required this.auctionTranID,
  });

  @override
  List<Object?> get props => [token, customerID, auctionTranID];

  Map<String, dynamic> toJson() {
    return {
      "Token": token,
      "CustomerID": customerID,
      "AuctionTranID": auctionTranID
    };
  }
}
