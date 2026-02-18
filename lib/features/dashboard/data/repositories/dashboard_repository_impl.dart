import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:tradologie_app/features/dashboard/data/models/all_list_detail_model.dart';
import 'package:tradologie_app/features/dashboard/data/models/commodity_list_model.dart';
import 'package:tradologie_app/features/dashboard/data/models/dashboard_result_model.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/all_list_detail.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/commodity_list.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/dashboard_result.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/add_customer_requirement_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_all_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/post_vendor_stock_requirement.dart';

import '../../../../core/error/user_failure.dart';
import '../../domain/respositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource dashboardRemoteDataSource;

  DashboardRepositoryImpl({
    required this.dashboardRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<DashboardResult>>> getDashboardData(
      GetDashboardParams params) async {
    try {
      final response = await dashboardRemoteDataSource.getDashboardData(params);
      if (response != null && response.success) {
        return Right((response.data as List)
            .map((e) => DashboardResultModel.fromJson(e))
            .toList());
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> addCustomerRequirement(
      AddCustomerRequirementParams params) async {
    try {
      final response =
          await dashboardRemoteDataSource.addCustomerRequirement(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, bool>> postVendorStockRequirement(
      PostVendorStockRequirementParams params) async {
    try {
      final response =
          await dashboardRemoteDataSource.postVendorStockRequirement(params);
      if (response != null && response.success) {
        return Right(response.data);
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<Failure, List<CommodityList>>> getCommodityList(
      NoParams params) async {
    try {
      final response = await dashboardRemoteDataSource.getCommodityList(params);
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
  Future<Either<Failure, AllListDetail>> getAllList(
      GetAllListParams params) async {
    try {
      final response = await dashboardRemoteDataSource.getAllList(params);
      if (response != null && response.success) {
        return Right(AllListDetailModel.fromJson(response.data));
      }
      return Left(UserFailure(response?.message, response?.code));
    } on Failure catch (e) {
      return Left(e);
    }
  }
}
