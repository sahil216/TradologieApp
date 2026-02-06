part of 'negotiation_cubit.dart';

abstract class NegotiationState extends Equatable {
  const NegotiationState();

  @override
  List<Object> get props => [];
}

class NegotiationInitial extends NegotiationState {}

class GetNegotiationIsLoading extends NegotiationState {}

class GetNegotiationSuccess extends NegotiationState {
  final Negotiation data;

  const GetNegotiationSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class GetNegotiationError extends NegotiationState {
  final Failure failure;

  const GetNegotiationError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class BuyerNegotiationIsLoading extends NegotiationState {}

class BuyerNegotiationSuccess extends NegotiationState {
  final BuyerNegotiation data;

  const BuyerNegotiationSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class BuyerNegotiationError extends NegotiationState {
  final Failure failure;

  const BuyerNegotiationError({required this.failure});

  @override
  List<Object> get props => [failure];
}
