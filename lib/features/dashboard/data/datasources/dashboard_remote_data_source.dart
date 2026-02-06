import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/add_customer_requirement_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_all_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_dashboard_usecase.dart';

import '../../../../core/api/api_consumer.dart';
import '../../../../core/api/end_points.dart';
import '../../../../core/response_wrapper/response_wrapper.dart';

abstract class DashboardRemoteDataSource {
  Future<ResponseWrapper<dynamic>?> getDashboardData(GetDashboardParams params);
  Future<ResponseWrapper<dynamic>?> addCustomerRequirement(
      AddCustomerRequirementParams params);
  Future<ResponseWrapper<dynamic>?> getCommodityList(NoParams params);
  Future<ResponseWrapper<dynamic>?> getAllList(GetAllListParams params);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  ApiConsumer apiConsumer;

  DashboardRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<ResponseWrapper<dynamic>?> getDashboardData(
      GetDashboardParams params) async {
    return await apiConsumer.post(
      EndPoints.getLiveAuctionDashboard,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> addCustomerRequirement(
      AddCustomerRequirementParams params) async {
    return await apiConsumer.post(
      EndPoints.addCustomerRequirement,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getAllList(GetAllListParams params) async {
    return await apiConsumer.post(
      EndPoints.getAllList,
      body: params.toJson(),
    );
  }

  @override
  Future<ResponseWrapper<dynamic>?> getCommodityList(NoParams params) async {
    return await apiConsumer.get(
      EndPoints.getCommodityList,
    );
  }
}
