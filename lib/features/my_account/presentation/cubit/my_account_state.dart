part of 'my_account_cubit.dart';

abstract class MyAccountState extends Equatable {
  const MyAccountState();

  @override
  List<Object> get props => [];
}

class MyAccountInitial extends MyAccountState {}

class SaveLoginControlIsLoading extends MyAccountState {}

class SaveLoginControlSuccess extends MyAccountState {
  final bool data;

  const SaveLoginControlSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class SaveLoginControlError extends MyAccountState {
  final Failure failure;

  const SaveLoginControlError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GetInformationIsLoading extends MyAccountState {}

class GetInformationSuccess extends MyAccountState {
  final GetInformationDetail data;

  const GetInformationSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class GetInformationError extends MyAccountState {
  final Failure failure;

  const GetInformationError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class CompanyDetailsIsLoading extends MyAccountState {}

class CompanyDetailsSuccess extends MyAccountState {
  final CompanyDetails data;

  const CompanyDetailsSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class CompanyDetailsError extends MyAccountState {
  final Failure failure;

  const CompanyDetailsError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class SaveInformationIsLoading extends MyAccountState {}

class SaveInformationSuccess extends MyAccountState {
  final bool data;

  const SaveInformationSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class SaveInformationError extends MyAccountState {
  final Failure failure;

  const SaveInformationError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class CompanyDetailIsLoading extends MyAccountState {}

class CompanyDetailSuccess extends MyAccountState {
  final bool data;

  const CompanyDetailSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class CompanyDetailError extends MyAccountState {
  final Failure failure;

  const CompanyDetailError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class DocumentsIsLoading extends MyAccountState {}

class DocumentsSuccess extends MyAccountState {
  final bool data;

  const DocumentsSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class DocumentsError extends MyAccountState {
  final Failure failure;

  const DocumentsError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AuthorizedPersonIsLoading extends MyAccountState {}

class AuthorizedPersonSuccess extends MyAccountState {
  final bool data;

  const AuthorizedPersonSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class AuthorizedPersonError extends MyAccountState {
  final Failure failure;

  const AuthorizedPersonError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class LegalDocumentsIsLoading extends MyAccountState {}

class LegalDocumentsSuccess extends MyAccountState {
  final bool data;

  const LegalDocumentsSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class LegalDocumentsError extends MyAccountState {
  final Failure failure;

  const LegalDocumentsError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class BankDetailsIsLoading extends MyAccountState {}

class BankDetailsSuccess extends MyAccountState {
  final bool data;

  const BankDetailsSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class BankDetailsError extends MyAccountState {
  final Failure failure;

  const BankDetailsError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class SellingLocationIsLoading extends MyAccountState {}

class SellingLocationSuccess extends MyAccountState {
  final bool data;

  const SellingLocationSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class SellingLocationError extends MyAccountState {
  final Failure failure;

  const SellingLocationError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class BulkRetailIsLoading extends MyAccountState {}

class BulkRetailSuccess extends MyAccountState {
  final bool data;

  const BulkRetailSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class BulkRetailError extends MyAccountState {
  final Failure failure;

  const BulkRetailError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class MembershipIsLoading extends MyAccountState {}

class MembershipSuccess extends MyAccountState {
  final bool data;

  const MembershipSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class MembershipError extends MyAccountState {
  final Failure failure;

  const MembershipError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class CommodityIsLoading extends MyAccountState {}

class CommoditySuccess extends MyAccountState {
  final bool data;

  const CommoditySuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class CommodityError extends MyAccountState {
  final Failure failure;

  const CommodityError({required this.failure});

  @override
  List<Object> get props => [failure];
}
