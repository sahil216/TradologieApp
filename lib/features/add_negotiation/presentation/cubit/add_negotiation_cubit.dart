import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/create_auction_detail.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/create_auction_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_category_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_shortlisted_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';

part 'add_negotiation_state.dart';

class AddNegotiationCubit extends Cubit<AddNegotiationState> {
  final GetCategoryUsecase getCategoryUsecase;
  final AddSupplierShortlistUsecase addSupplierShortlistUsecase;
  final DeleteSupplierShortlistUsecase deleteSupplierShortlistUsecase;
  final GetSupplierListUsecase getSupplierListUsecase;
  final GetSupplierShortlistedUsecase getSupplierShortlistedUsecase;
  final CreateAuctionUsecase createAuctionUsecase;

  AddNegotiationCubit({
    required this.getCategoryUsecase,
    required this.addSupplierShortlistUsecase,
    required this.deleteSupplierShortlistUsecase,
    required this.getSupplierListUsecase,
    required this.getSupplierShortlistedUsecase,
    required this.createAuctionUsecase,
  }) : super(AddNegotiationInitial());

  Future<void> getCategoryList(NoParams params) async {
    emit(GetCategoryIsLoading());
    Either<Failure, List<CommodityList>> response =
        await getCategoryUsecase(params);
    emit(response.fold(
      (failure) => GetCategoryError(failure: failure),
      (res) => GetCategorySuccess(data: res),
    ));
  }

  Future<void> addSupplierShortlist(AddShortListSupplierParams params) async {
    emit(AddSupplierShortlistIsLoading());
    Either<Failure, bool> response = await addSupplierShortlistUsecase(params);
    emit(response.fold(
      (failure) => AddSupplierShortlistError(failure: failure),
      (res) => AddSupplierShortlistSuccess(data: res),
    ));
  }

  Future<void> deleteSupplierShortlist(
      RemoveSupplierShortlistParams params) async {
    emit(DeleteSupplierShortlistIsLoading());
    Either<Failure, bool> response =
        await deleteSupplierShortlistUsecase(params);
    emit(response.fold(
      (failure) => DeleteSupplierShortlistError(failure: failure),
      (res) => DeleteSupplierShortlistSuccess(data: res),
    ));
  }

  Future<void> getSupplierList(SupplierListParams params) async {
    emit(GetSupplierListIsLoading());
    Either<Failure, List<SupplierList>> response =
        await getSupplierListUsecase(params);
    emit(response.fold(
      (failure) => GetSupplierListError(failure: failure),
      (res) => GetSupplierListSuccess(data: res),
    ));
  }

  Future<void> getSupplierShortlisted(SupplierListParams params) async {
    emit(GetSupplierShortistedIsLoading());
    Either<Failure, List<SupplierList>> response =
        await getSupplierShortlistedUsecase(params);
    emit(response.fold(
      (failure) => GetSupplierShortistedError(failure: failure),
      (res) => GetSupplierShortistedSuccess(data: res),
    ));
  }

  Future<void> createAuction(CreateAuctionParams params) async {
    emit(CreateAuctionIsLoading());
    Either<Failure, CreateAuctionDetail> response =
        await createAuctionUsecase(params);
    emit(response.fold(
      (failure) => CreateAuctionError(failure: failure),
      (res) => CreateAuctionSuccess(data: res),
    ));
  }

  bool isSupplierShortlisted({
    required SupplierList supplier,
    required List<SupplierList>? shortlisted,
  }) {
    if (shortlisted == null || shortlisted.isEmpty) return false;

    return shortlisted.any(
      (item) => item.vendorId == supplier.vendorId,
    );
  }
}
