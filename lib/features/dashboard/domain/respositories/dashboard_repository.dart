import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/all_list_detail.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/auction_unit_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/dashboard_result.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/get_vendor_stock_list.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/add_customer_requirement_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/add_vendor_stock_enquiry_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_all_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_vendor_stock_listing_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/post_vendor_stock_requirement.dart';

import '../../../../core/error/failures.dart';
import '../entities/commodity_list.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<DashboardResult>>> getDashboardData(
      GetDashboardParams params);
  Future<Either<Failure, bool>> addCustomerRequirement(
      AddCustomerRequirementParams params);
  Future<Either<Failure, bool>> postVendorStockRequirement(
      PostVendorStockRequirementParams params);
  Future<Either<Failure, List<CommodityList>>> getCommodityList(
      NoParams params);
  Future<Either<Failure, AllListDetail>> getAllList(GetAllListParams params);
  Future<Either<Failure, List<GetVendorStockList>>> getReadyStockListing(
      GetVendorStockListingParams params);
  Future<Either<Failure, List<AuctionUnitList>>> getAuctionUnit(String params);
  Future<Either<Failure, bool>> addVendorStockEnquiry(
      AddVendorStockEnquiryParams params);
}
