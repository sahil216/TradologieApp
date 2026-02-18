import 'package:equatable/equatable.dart';

import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class AddAuctionSupplierUsecase
    implements UseCase<bool, AddAuctionSupplierParams> {
  final AddNegotiationRepository addNegotiationRepository;

  AddAuctionSupplierUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, bool>> call(AddAuctionSupplierParams params) =>
      addNegotiationRepository.addAuctionSupplier(params);
}

class AddAuctionSupplierParams extends Equatable {
  final String token;
  final String customerID;
  final String auctionID;
  final String supplier;

  const AddAuctionSupplierParams({
    required this.token,
    required this.customerID,
    required this.auctionID,
    required this.supplier,
  });

  @override
  List<Object?> get props => [token, customerID, auctionID, supplier];

  Map<String, dynamic> toJson() {
    return {
      "Token": token,
      "CustomerID": customerID,
      "AuctionID": auctionID,
      "Supplier": supplier
    };
  }
}
