import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/create_auction_detail.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/create_auction_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';

abstract class AddNegotiationRepository {
  Future<Either<Failure, List<CommodityList>>> getCategoryList(NoParams params);
  Future<Either<Failure, bool>> addSupplierShortList(
      AddShortListSupplierParams params);
  Future<Either<Failure, bool>> deleteSupplierShortList(
      RemoveSupplierShortlistParams params);
  Future<Either<Failure, GetSupplierData>> getSupplierList(
      SupplierListParams params);
  Future<Either<Failure, List<SupplierList>>> getSupplierShortlisted(
      SupplierListParams params);
  Future<Either<Failure, CreateAuctionDetail>> createAuction(
      CreateAuctionParams params);
}
