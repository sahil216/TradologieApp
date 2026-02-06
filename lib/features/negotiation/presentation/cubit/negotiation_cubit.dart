import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/features/negotiation/domain/usecases/get_negotiation_usecase.dart';

import '../../domain/entities/buyer_negotiation.dart';
import '../../domain/entities/negotiation.dart';
import '../../domain/usecases/buyer_negotiation_usecase.dart';

part 'negotiation_state.dart';

class NegotiationCubit extends Cubit<NegotiationState> {
  final GetNegotiationUsecase negotiationUsecase;
  final BuyerNegotiationUsecase buyerNegotiationUsecase;

  NegotiationCubit({
    required this.negotiationUsecase,
    required this.buyerNegotiationUsecase,
  }) : super(NegotiationInitial());

  Future<void> getNegotiationData(GetNegotiationParams params) async {
    emit(GetNegotiationIsLoading());
    Either<Failure, Negotiation> response = await negotiationUsecase(params);
    emit(response.fold(
      (failure) => GetNegotiationError(failure: failure),
      (res) => GetNegotiationSuccess(data: res),
    ));
  }

  Future<void> buyerNegotiationData(GetNegotiationParams params) async {
    emit(BuyerNegotiationIsLoading());
    Either<Failure, BuyerNegotiation> response =
        await buyerNegotiationUsecase(params);
    emit(response.fold(
      (failure) => BuyerNegotiationError(failure: failure),
      (res) => BuyerNegotiationSuccess(data: res),
    ));
  }
}
