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
  final GetSupplierData data;

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
  final GetSupplierData data;

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

class CreateAuctionIsLoading extends AddNegotiationState {}

class CreateAuctionSuccess extends AddNegotiationState {
  final CreateAuctionDetail data;

  const CreateAuctionSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class CreateAuctionError extends AddNegotiationState {
  final Failure failure;

  const CreateAuctionError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AuctionItemListIsLoading extends AddNegotiationState {}

class AuctionItemListSuccess extends AddNegotiationState {
  final List<AuctionItemListData> data;

  const AuctionItemListSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class AuctionItemListError extends AddNegotiationState {
  final Failure failure;

  const AuctionItemListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GradleFileUploadIsLoading extends AddNegotiationState {}

class GradleFileUploadSuccess extends AddNegotiationState {
  final bool data;

  const GradleFileUploadSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class GradleFileUploadError extends AddNegotiationState {
  final Failure failure;

  const GradleFileUploadError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class PackingImageUploadIsLoading extends AddNegotiationState {}

class PackingImageUploadSuccess extends AddNegotiationState {
  final bool data;

  const PackingImageUploadSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class PackingImageUploadError extends AddNegotiationState {
  final Failure failure;

  const PackingImageUploadError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AddAuctionItemIsLoading extends AddNegotiationState {}

class AddAuctionItemSuccess extends AddNegotiationState {
  final bool data;

  const AddAuctionItemSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class AddAuctionItemError extends AddNegotiationState {
  final Failure failure;

  const AddAuctionItemError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AuctionDetailForEditIsLoading extends AddNegotiationState {}

class AuctionDetailForEditSuccess extends AddNegotiationState {
  final AuctionDetailForEditData data;

  const AuctionDetailForEditSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class AuctionDetailForEditError extends AddNegotiationState {
  final Failure failure;

  const AuctionDetailForEditError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AddAuctionSupplierIsLoading extends AddNegotiationState {}

class AddAuctionSupplierSuccess extends AddNegotiationState {
  final bool data;

  const AddAuctionSupplierSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class AddAuctionSupplierError extends AddNegotiationState {
  final Failure failure;

  const AddAuctionSupplierError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AddAuctionSupplierListIsLoading extends AddNegotiationState {}

class AddAuctionSupplierListSuccess extends AddNegotiationState {
  final List<AddAuctionSupplierListData> data;

  const AddAuctionSupplierListSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class AddAuctionSupplierListError extends AddNegotiationState {
  final Failure failure;

  const AddAuctionSupplierListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class DeleteAuctionItemIsLoading extends AddNegotiationState {}

class DeleteAuctionItemSuccess extends AddNegotiationState {
  final bool data;

  const DeleteAuctionItemSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class DeleteAuctionItemError extends AddNegotiationState {
  final Failure failure;

  const DeleteAuctionItemError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AddUpdateAuctionIsLoading extends AddNegotiationState {}

class AddUpdateAuctionSuccess extends AddNegotiationState {
  final AddUpdateAuctionData data;

  const AddUpdateAuctionSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class AddUpdateAuctionError extends AddNegotiationState {
  final Failure failure;

  const AddUpdateAuctionError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AuctionSupplierListIsLoading extends AddNegotiationState {}

class AuctionSupplierListSuccess extends AddNegotiationState {
  final List<AddAuctionSupplierListData> data;

  const AuctionSupplierListSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class AuctionSupplierListError extends AddNegotiationState {
  final Failure failure;

  const AuctionSupplierListError({required this.failure});

  @override
  List<Object> get props => [failure];
}
