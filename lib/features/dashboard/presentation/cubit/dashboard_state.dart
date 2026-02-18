part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class GetDashboardIsLoading extends DashboardState {}

class GetDashboardSuccess extends DashboardState {
  final List<DashboardResult> data;

  const GetDashboardSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class GetDashboardError extends DashboardState {
  final Failure failure;

  const GetDashboardError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class AddCustomerRequirementIsLoading extends DashboardState {}

class AddCustomerRequirementSuccess extends DashboardState {
  final bool data;

  const AddCustomerRequirementSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class AddCustomerRequirementError extends DashboardState {
  final Failure failure;

  const AddCustomerRequirementError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class PostVendorStockRequirementIsLoading extends DashboardState {}

class PostVendorStockRequirementSuccess extends DashboardState {
  final bool data;

  const PostVendorStockRequirementSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class PostVendorStockRequirementError extends DashboardState {
  final Failure failure;

  const PostVendorStockRequirementError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GetCommodityListIsLoading extends DashboardState {}

class GetCommodityListSuccess extends DashboardState {
  final List<CommodityList> data;

  const GetCommodityListSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class GetCommodityListError extends DashboardState {
  final Failure failure;

  const GetCommodityListError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class GetAllListIsLoading extends DashboardState {}

class GetAllListSuccess extends DashboardState {
  final AllListDetail data;

  const GetAllListSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

class GetAllListError extends DashboardState {
  final Failure failure;

  const GetAllListError({required this.failure});

  @override
  List<Object> get props => [failure];
}
