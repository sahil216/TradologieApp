part of 'admin_vendor_cubit.dart';

abstract class AdminVendorState extends Equatable {
  const AdminVendorState();

  @override
  List<Object?> get props => [];
}

class AdminVendorInitial extends AdminVendorState {}

class AdminVendorListLoading extends AdminVendorState {}

class AdminVendorListSuccess extends AdminVendorState {
  final List<AdminVendor> vendors;
  final bool isSearchResults;

  const AdminVendorListSuccess({
    required this.vendors,
    this.isSearchResults = false,
  });

  @override
  List<Object?> get props => [vendors, isSearchResults];
}

class AdminVendorListError extends AdminVendorState {
  final Failure failure;

  const AdminVendorListError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
