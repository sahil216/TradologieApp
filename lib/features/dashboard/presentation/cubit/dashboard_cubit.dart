import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/entities/all_list_detail.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/add_customer_requirement_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_all_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_commodity_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_dashboard_usecase.dart';

import '../../domain/entities/commodity_list.dart';
import '../../domain/entities/dashboard_result.dart';
part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardUsecase dashboardUsecase;
  final AddCustomerRequirementUsecase addCustomerRequirementUsecase;
  final GetCommodityListUsecase getCommodityListUsecase;
  final GetAllListUsecase getAllListUsecase;

  DashboardCubit({
    required this.dashboardUsecase,
    required this.addCustomerRequirementUsecase,
    required this.getCommodityListUsecase,
    required this.getAllListUsecase,
  }) : super(DashboardInitial());

  Future<void> getDashboardData(GetDashboardParams params) async {
    emit(GetDashboardIsLoading());
    Either<Failure, List<DashboardResult>> response =
        await dashboardUsecase(params);
    emit(response.fold(
      (failure) => GetDashboardError(failure: failure),
      (res) => GetDashboardSuccess(data: res),
    ));
  }

  Future<void> addCustomerRequirement(
      AddCustomerRequirementParams params) async {
    emit(AddCustomerRequirementIsLoading());
    Either<Failure, bool> response =
        await addCustomerRequirementUsecase(params);
    emit(response.fold(
      (failure) => AddCustomerRequirementError(failure: failure),
      (res) => AddCustomerRequirementSuccess(data: res),
    ));
  }

  Future<void> getCommodityList(NoParams params) async {
    emit(GetCommodityListIsLoading());
    Either<Failure, List<CommodityList>> response =
        await getCommodityListUsecase(params);
    emit(response.fold(
      (failure) => GetCommodityListError(failure: failure),
      (res) => GetCommodityListSuccess(data: res),
    ));
  }

  Future<void> getAllList(
    GetAllListParams params,
  ) async {
    emit(GetAllListIsLoading());
    Either<Failure, AllListDetail> response = await getAllListUsecase(params);
    emit(response.fold(
      (failure) => GetAllListError(failure: failure),
      (res) => GetAllListSuccess(data: res),
    ));
  }
}
