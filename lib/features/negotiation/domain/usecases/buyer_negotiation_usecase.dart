import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/buyer_negotiation.dart';

import '../../../../core/error/failures.dart';
import '../respositories/negotiation_repository.dart';
import 'get_negotiation_usecase.dart';

class BuyerNegotiationUsecase
    implements UseCase<BuyerNegotiation, GetNegotiationParams> {
  final NegotiationRepository negotiationRepository;

  BuyerNegotiationUsecase({required this.negotiationRepository});
  @override
  Future<Either<Failure, BuyerNegotiation>> call(GetNegotiationParams params) =>
      negotiationRepository.buyerNegotiationData(params);
}
