import 'package:dartz/dartz.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/buyer_negotiation.dart';

import '../../../../core/error/failures.dart';
import '../entities/negotiation.dart';
import '../usecases/demo_negotiation_usecase.dart';
import '../usecases/get_negotiation_usecase.dart';

abstract class NegotiationRepository {
  Future<Either<Failure, Negotiation>> getNegotiationData(
      GetNegotiationParams params);
  Future<Either<Failure, BuyerNegotiation>> buyerNegotiationData(
      GetNegotiationParams params);
  Future<Either<Failure, Negotiation>> demoNegotiationData(
      DemoNegotiationParams params);
}
