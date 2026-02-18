import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/data/datasources/add_negotiation_remote_data_source.dart';
import 'package:tradologie_app/features/add_negotiation/data/models/add_auction_supplier_list_data_model.dart';
import 'package:tradologie_app/features/add_negotiation/data/models/auction_detail_for_edit_data_model.dart';
import 'package:tradologie_app/features/add_negotiation/data/models/auction_item_list_data_model.dart';
import 'package:tradologie_app/features/add_negotiation/data/models/create_auction_detail_model.dart';
import 'package:tradologie_app/features/add_negotiation/data/models/get_supplier_data_model.dart';
import 'package:tradologie_app/features/add_negotiation/data/models/get_supplier_list_model.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/add_auction_supplier_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_detail_for_edit_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_item_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/create_auction_detail.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_item_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_supplier_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_detail_for_edit_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_item_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/create_auction_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_auction_item_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/data/models/commodity_list_model.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';

class AddNegotiationRepositoryImpl implements AddNegotiationRepository {
  final AddNegotiationRemoteDataSource addNegotiationRemoteDataSource;

  AddNegotiationRepositoryImpl({
    required this.addNegotiationRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<CommodityList>>> getCategoryList(
      NoParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.getCategoryList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => CommodityListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> addSupplierShortList(
      AddShortListSupplierParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.addSupplierShortList(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteSupplierShortList(
      RemoveSupplierShortlistParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.deleteSupplierShortList(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, GetSupplierData>> getSupplierList(
      SupplierListParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.getSupplierList(params);
      if (response != null && response.success) {
        return Right(GetSupplierDataModel.fromJson(response.data));

        // Right((response.data as List)
        //     .map((e) => SupplierListModel.fromJson(e))
        //     .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<SupplierList>>> getSupplierShortlisted(
      SupplierListParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.getSupplierShortlisted(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => SupplierListModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, CreateAuctionDetail>> createAuction(
      CreateAuctionParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.createAuction(params);
      if (response != null && response.success) {
        return Right(CreateAuctionDetailModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<AuctionItemListData>>> auctionItemList(
      AuctionItemListParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.auctionItemList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => AuctionItemListDataModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> gradleFileUpload(NoParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.gradleFileUpload(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> packingImageUpload(NoParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.packingImageUpload(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> addAuctionItem(
      AddAuctionItemParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.addAuctionItem(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, AuctionDetailForEditData>> auctionDetailForEdit(
      AuctionDetailForEditParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.auctionDetailForEdit(params);
      if (response != null && response.success) {
        return Right(AuctionDetailForEditDataModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> addAuctionSupplier(
      AddAuctionSupplierParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.addAuctionSupplier(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<AddAuctionSupplierListData>>>
      addAuctionSupplierList(NoParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.addAuctionSupplierList(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => AddAuctionSupplierListDataModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAuctionItem(
      DeleteAuctionItemParams params) async {
    try {
      final response =
          await addNegotiationRemoteDataSource.deleteAuctionItem(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
