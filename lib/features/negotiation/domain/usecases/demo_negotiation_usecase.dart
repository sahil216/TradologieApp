import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/negotiation.dart';
import '../respositories/negotiation_repository.dart';

class DemoNegotiationUsecase
    implements UseCase<Negotiation, DemoNegotiationParams> {
  final NegotiationRepository negotiationRepository;

  DemoNegotiationUsecase({required this.negotiationRepository});

  @override
  Future<Either<Failure, Negotiation>> call(DemoNegotiationParams params) =>
      negotiationRepository.demoNegotiationData(params);
}

class DemoNegotiationParams extends Equatable {
  final String token;
  final String filterAuction;
  final int indexNo;

  const DemoNegotiationParams({
    required this.token,
    required this.filterAuction,
    required this.indexNo,
  });

  @override
  List<Object?> get props => [token, filterAuction, indexNo];

  Map<String, dynamic> toJson() => {
        "Token": token,
        "FilterAuction": filterAuction,
        "IndexNo": indexNo,
      };
}
