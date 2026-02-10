part of 'add_negotiation_cubit.dart';

abstract class AddNegotiationState extends Equatable {
  const AddNegotiationState();

  @override
  List<Object> get props => [];
}

class AddNegotiationInitial extends AddNegotiationState {}

class GetCategoryIsLoading extends AddNegotiationState {}

class GetCategorySuccess extends AddNegotiationState {
  final List<CommodityList> data;

  const GetCategorySuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class GetCategoryError extends AddNegotiationState {
  final Failure failure;

  const GetCategoryError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AddSupplierShortlistIsLoading extends AddNegotiationState {}

class AddSupplierShortlistSuccess extends AddNegotiationState {
  final bool data;

  const AddSupplierShortlistSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class AddSupplierShortlistError extends AddNegotiationState {
  final Failure failure;

  const AddSupplierShortlistError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class DeleteSupplierShortlistIsLoading extends AddNegotiationState {}

class DeleteSupplierShortlistSuccess extends AddNegotiationState {
  final bool data;

  const DeleteSupplierShortlistSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteSupplierShortlistError extends AddNegotiationState {
  final Failure failure;

  const DeleteSupplierShortlistError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GetSupplierListIsLoading extends AddNegotiationState {}

class GetSupplierListSuccess extends AddNegotiationState {
  final List<SupplierList> data;

  const GetSupplierListSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class GetSupplierListError extends AddNegotiationState {
  final Failure failure;

  const GetSupplierListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GetSupplierShortistedIsLoading extends AddNegotiationState {}

class GetSupplierShortistedSuccess extends AddNegotiationState {
  final List<SupplierList> data;

  const GetSupplierShortistedSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class GetSupplierShortistedError extends AddNegotiationState {
  final Failure failure;

  const GetSupplierShortistedError({required this.failure});

  @override
  List<Object> get props => [failure];
}
