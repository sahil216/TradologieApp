part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class SendOtpIsLoading extends AuthenticationState {}

class SendOtpSuccess extends AuthenticationState {
  final SendOtpResult data;
  final bool isResend;

  const SendOtpSuccess({required this.data, required this.isResend});

  @override
  List<Object> get props => [data, isResend];
}

class SendOtpError extends AuthenticationState {
  final Failure failure;

  const SendOtpError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class VerifyOtpIsLoading extends AuthenticationState {}

class VerifyOtpSuccess extends AuthenticationState {
  final VerifyOtpResult data;

  const VerifyOtpSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class VerifyOtpError extends AuthenticationState {
  final Failure failure;

  const VerifyOtpError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class RegisterIsLoading extends AuthenticationState {}

class RegisterSuccess extends AuthenticationState {
  final bool success;

  const RegisterSuccess({required this.success});

  @override
  List<Object> get props => [success];
}

class RegisterError extends AuthenticationState {
  final Failure failure;

  const RegisterError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class SigninIsLoading extends AuthenticationState {}

class SigninSuccess extends AuthenticationState {
  final LoginSuccess? data;

  const SigninSuccess({required this.data});

  @override
  List<Object> get props => [data!];
}

class BuyerSigninSuccess extends AuthenticationState {
  final BuyerLoginSuccess? data;

  const BuyerSigninSuccess({required this.data});

  @override
  List<Object> get props => [data!];
}

class SigninError extends AuthenticationState {
  final Failure failure;

  const SigninError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class SignOutIsLoading extends AuthenticationState {}

class SignOutSuccess extends AuthenticationState {
  final bool success;

  const SignOutSuccess({required this.success});

  @override
  List<Object> get props => [success];
}

class SignOutError extends AuthenticationState {
  final Failure failure;

  const SignOutError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class DeleteAccountIsLoading extends AuthenticationState {}

class DeleteAccountSuccess extends AuthenticationState {
  final bool success;

  const DeleteAccountSuccess({required this.success});

  @override
  List<Object> get props => [success];
}

class DeleteAccountError extends AuthenticationState {
  final Failure failure;

  const DeleteAccountError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GetCountryCodeListIsLoading extends AuthenticationState {}

class GetCountryCodeListSuccess extends AuthenticationState {
  final List<CountryCodeList> data;

  const GetCountryCodeListSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class GetCountryCodeListError extends AuthenticationState {
  final Failure failure;

  const GetCountryCodeListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class FmcgSellerSigninIsLoading extends AuthenticationState {}

class FmcgSellerSigninSuccess extends AuthenticationState {
  final FmcgSellerSigninResponse data;

  const FmcgSellerSigninSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class FmcgSellerSigninError extends AuthenticationState {
  final Failure failure;

  const FmcgSellerSigninError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class FmcgBuyerSigninIsLoading extends AuthenticationState {}

class FmcgBuyerSigninSuccess extends AuthenticationState {
  final FmcgBuyerLoginSuccess data;

  const FmcgBuyerSigninSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class FmcgBuyerSigninError extends AuthenticationState {
  final Failure failure;

  const FmcgBuyerSigninError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class FmcgRegisterSellerIsLoading extends AuthenticationState {}

class FmcgRegisterSellerSuccess extends AuthenticationState {
  final FmcgSellerSigninResponse data;

  const FmcgRegisterSellerSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class FmcgRegisterSellerError extends AuthenticationState {
  final Failure failure;

  const FmcgRegisterSellerError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class FmcgRegisterDistributorIsLoading extends AuthenticationState {}

class FmcgRegisterDistributorSuccess extends AuthenticationState {
  final FmcgBuyerLoginSuccess data;

  const FmcgRegisterDistributorSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class FmcgRegisterDistributorError extends AuthenticationState {
  final Failure failure;

  const FmcgRegisterDistributorError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class FmcgCountryCodeListIsLoading extends AuthenticationState {}

class FmcgCountryCodeListSuccess extends AuthenticationState {
  final List<FmcgCountryCodeList> data;

  const FmcgCountryCodeListSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class FmcgCountryCodeListError extends AuthenticationState {
  final Failure failure;

  const FmcgCountryCodeListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class FmcgBrandsListIsLoading extends AuthenticationState {}

class FmcgBrandsListSuccess extends AuthenticationState {
  final List<FmcgBrandsList> data;

  const FmcgBrandsListSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class FmcgBrandsListError extends AuthenticationState {
  final Failure failure;

  const FmcgBrandsListError({required this.failure});

  @override
  List<Object> get props => [failure];
}
