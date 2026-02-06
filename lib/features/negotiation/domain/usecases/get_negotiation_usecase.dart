import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../../core/utils/constants.dart';
import '../entities/negotiation.dart';
import '../respositories/negotiation_repository.dart';

class GetNegotiationUsecase
    implements UseCase<Negotiation, GetNegotiationParams> {
  final NegotiationRepository negotiationRepository;

  GetNegotiationUsecase({required this.negotiationRepository});
  @override
  Future<Either<Failure, Negotiation>> call(GetNegotiationParams params) =>
      negotiationRepository.getNegotiationData(params);
}

class GetNegotiationParams extends Equatable {
  final String token;
  final String filterAuction;
  final String? vendorID;
  final String? customerID;
  final int indexNo;

  const GetNegotiationParams(
      {required this.token,
      required this.filterAuction,
      this.vendorID,
      this.customerID,
      required this.indexNo});

  @override
  List<Object?> get props => [token];

  Map<String, dynamic> toJson() => {
        "Token": token,
        "FilterAuction": filterAuction,
        if (Constants.isBuyer)
          "CustomerID": customerID
        else
          "VendorID": vendorID,
        "IndexNo": indexNo,
      };
}
