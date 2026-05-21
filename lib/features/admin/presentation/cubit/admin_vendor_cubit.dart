import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/admin_vendor.dart';
import '../../domain/usecases/get_admin_vendor_list_usecase.dart';
import '../../domain/usecases/get_agro_seller_chat_list_usecase.dart';

part 'admin_vendor_state.dart';

class AdminVendorCubit extends Cubit<AdminVendorState> {
  static const int minSearchLength = 3;

  final GetAdminVendorListUsecase getAdminVendorListUsecase;
  final GetAgroSellerChatListUsecase getAgroSellerChatListUsecase;

  List<AdminVendor> _recentChats = [];

  AdminVendorCubit({
    required this.getAdminVendorListUsecase,
    required this.getAgroSellerChatListUsecase,
  }) : super(AdminVendorInitial());

  Future<void> loadRecentChats() async {
    emit(AdminVendorListLoading());
    final response = await getAgroSellerChatListUsecase(NoParams());
    emit(response.fold(
      (failure) => AdminVendorListError(failure: failure),
      (vendors) {
        _recentChats = vendors;
        return AdminVendorListSuccess(
          vendors: vendors,
          isSearchResults: false,
        );
      },
    ));
  }

  Future<void> searchVendors({
    required String query,
    required AdminVendorSearchType searchType,
  }) async {
    final trimmed = query.trim();

    if (trimmed.length < minSearchLength) {
      restoreRecentChats();
      return;
    }

    emit(AdminVendorListLoading());
    final response = await getAdminVendorListUsecase(
      GetAdminVendorListParams(
        query: trimmed,
        searchType: searchType,
      ),
    );

    emit(response.fold(
      (failure) => AdminVendorListError(failure: failure),
      (vendors) => AdminVendorListSuccess(
        vendors: vendors,
        isSearchResults: true,
      ),
    ));
  }

  void restoreRecentChats() {
    if (_recentChats.isNotEmpty) {
      emit(AdminVendorListSuccess(
        vendors: _recentChats,
        isSearchResults: false,
      ));
    } else {
      emit(AdminVendorInitial());
    }
  }
}
