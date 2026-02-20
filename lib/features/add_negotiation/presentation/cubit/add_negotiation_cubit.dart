import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/add_auction_supplier_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/add_update_auction_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_detail_for_edit_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_item_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/create_auction_detail.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_item_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_supplier_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_supplier_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_update_auction_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_detail_for_edit_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_item_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/create_auction_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_auction_item_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_category_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_shortlisted_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/gradle_file_upload_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/packing_image_upload_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';

part 'add_negotiation_state.dart';

class AddNegotiationCubit extends Cubit<AddNegotiationState> {
  final GetCategoryUsecase getCategoryUsecase;
  final AddSupplierShortlistUsecase addSupplierShortlistUsecase;
  final DeleteSupplierShortlistUsecase deleteSupplierShortlistUsecase;
  final GetSupplierListUsecase getSupplierListUsecase;
  final GetSupplierShortlistedUsecase getSupplierShortlistedUsecase;
  final CreateAuctionUsecase createAuctionUsecase;
  final AuctionItemListUsecase auctionItemListUsecase;
  final GradleFileUploadUsecase gradleFileUploadUsecase;
  final PackingImageUploadUsecase packingImageUploadUsecase;
  final AddAuctionItemUsecase addAuctionItemUsecase;
  final AuctionDetailForEditUsecase auctionDetailForEditUsecase;
  final AddAuctionSupplierUsecase addAuctionSupplierUsecase;
  final AddAuctionSupplierListUsecase addAuctionSupplierListUsecase;
  final DeleteAuctionItemUsecase deleteAuctionItemUsecase;
  final AddUpdateAuctionUsecase addUpdateAuctionUsecase;

  AddNegotiationCubit({
    required this.getCategoryUsecase,
    required this.addSupplierShortlistUsecase,
    required this.deleteSupplierShortlistUsecase,
    required this.getSupplierListUsecase,
    required this.getSupplierShortlistedUsecase,
    required this.createAuctionUsecase,
    required this.auctionItemListUsecase,
    required this.gradleFileUploadUsecase,
    required this.packingImageUploadUsecase,
    required this.addAuctionItemUsecase,
    required this.auctionDetailForEditUsecase,
    required this.addAuctionSupplierUsecase,
    required this.addAuctionSupplierListUsecase,
    required this.deleteAuctionItemUsecase,
    required this.addUpdateAuctionUsecase,
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
    Either<Failure, GetSupplierData> response =
        await getSupplierListUsecase(params);
    emit(response.fold(
      (failure) => GetSupplierListError(failure: failure),
      (res) => GetSupplierListSuccess(data: res),
    ));
  }

  Future<void> getSupplierShortlisted(SupplierListParams params) async {
    emit(GetSupplierShortistedIsLoading());
    Either<Failure, GetSupplierData> response =
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

  Future<void> auctionItemList(AuctionItemListParams params) async {
    emit(AuctionItemListIsLoading());
    Either<Failure, List<AuctionItemListData>> response =
        await auctionItemListUsecase(params);
    emit(response.fold(
      (failure) => AuctionItemListError(failure: failure),
      (res) => AuctionItemListSuccess(data: res),
    ));
  }

  Future<void> gradleFileUpload(NoParams params) async {
    emit(GradleFileUploadIsLoading());
    Either<Failure, bool> response = await gradleFileUploadUsecase(params);
    emit(response.fold(
      (failure) => GradleFileUploadError(failure: failure),
      (res) => GradleFileUploadSuccess(data: res),
    ));
  }

  Future<void> packingImageUpload(NoParams params) async {
    emit(PackingImageUploadIsLoading());
    Either<Failure, bool> response = await packingImageUploadUsecase(params);
    emit(response.fold(
      (failure) => PackingImageUploadError(failure: failure),
      (res) => PackingImageUploadSuccess(data: res),
    ));
  }

  Future<void> addAuctionItem(AddAuctionItemParams params) async {
    emit(AddAuctionItemIsLoading());
    Either<Failure, bool> response = await addAuctionItemUsecase(params);
    emit(response.fold(
      (failure) => AddAuctionItemError(failure: failure),
      (res) => AddAuctionItemSuccess(data: res),
    ));
  }

  Future<void> auctionDetailForEdit(AuctionDetailForEditParams params) async {
    emit(AuctionDetailForEditIsLoading());
    Either<Failure, AuctionDetailForEditData> response =
        await auctionDetailForEditUsecase(params);
    emit(response.fold(
      (failure) => AuctionDetailForEditError(failure: failure),
      (res) => AuctionDetailForEditSuccess(data: res),
    ));
  }

  Future<void> addAuctionSupplier(AddAuctionSupplierParams params) async {
    emit(AddAuctionSupplierIsLoading());
    Either<Failure, bool> response = await addAuctionSupplierUsecase(params);
    emit(response.fold(
      (failure) => AddAuctionSupplierError(failure: failure),
      (res) => AddAuctionSupplierSuccess(data: res),
    ));
  }

  Future<void> addAuctionSupplierList(NoParams params) async {
    emit(AddAuctionSupplierListIsLoading());
    Either<Failure, List<AddAuctionSupplierListData>> response =
        await addAuctionSupplierListUsecase(params);
    emit(response.fold(
      (failure) => AddAuctionSupplierListError(failure: failure),
      (res) => AddAuctionSupplierListSuccess(data: res),
    ));
  }

  Future<void> deleteAuctionItem(DeleteAuctionItemParams params) async {
    emit(DeleteAuctionItemIsLoading());
    Either<Failure, bool> response = await deleteAuctionItemUsecase(params);
    emit(response.fold(
      (failure) => DeleteAuctionItemError(failure: failure),
      (res) => DeleteAuctionItemSuccess(data: res),
    ));
  }

  Future<void> addUpdateAuction(AddUpdateAuctionParams params) async {
    emit(AddUpdateAuctionIsLoading());
    Either<Failure, AddUpdateAuctionData> response =
        await addUpdateAuctionUsecase(params);
    emit(response.fold(
      (failure) => AddUpdateAuctionError(failure: failure),
      (res) => AddUpdateAuctionSuccess(data: res),
    ));
  }
}
