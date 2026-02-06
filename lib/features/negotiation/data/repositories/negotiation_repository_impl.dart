import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/features/negotiation/data/datasources/negotiation_remote_data_source.dart';
import 'package:tradologie_app/features/negotiation/data/models/buyer_negotitation_model.dart';
import 'package:tradologie_app/features/negotiation/data/models/negotiation_model.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/buyer_negotiation.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/negotiation.dart';
import 'package:tradologie_app/features/negotiation/domain/usecases/get_negotiation_usecase.dart';

import '../../../../core/error/user_failure.dart';
import '../../domain/respositories/negotiation_repository.dart';

class NegotiationRepositoryImpl implements NegotiationRepository {
  final NegotiationRemoteDataSource negotiationRemoteDataSource;

  NegotiationRepositoryImpl({
    required this.negotiationRemoteDataSource,
  });

  @override
  Future<Either<Failure, Negotiation>> getNegotiationData(
      GetNegotiationParams params) async {
    try {
      final response =
          await negotiationRemoteDataSource.getNegotiationData(params);
      if (response != null && response.success) {
        return Right(NegotiationModel.fromJson(response.data));

        // Right((response.data as List)
        //     .map((e) => NegotiationModel.fromJson(e))
        //     .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, BuyerNegotiation>> buyerNegotiationData(
      GetNegotiationParams params) async {
    try {
      final response =
          await negotiationRemoteDataSource.buyerNegotiationData(params);
      if (response != null && response.success) {
        return Right(BuyerNegotiationModel.fromJson(response.data));

        // Right((response.data as List)
        //     .map((e) => NegotiationModel.fromJson(e))
        //     .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
