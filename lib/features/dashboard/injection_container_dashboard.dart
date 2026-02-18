import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:tradologie_app/features/dashboard/domain/respositories/dashboard_repository.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/add_customer_requirement_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_all_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_commodity_list_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:tradologie_app/features/dashboard/domain/usecases/post_vendor_stock_requirement.dart';
import 'data/repositories/dashboard_repository_impl.dart';
import 'presentation/cubit/dashboard_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<DashboardCubit>(() => DashboardCubit(
        addCustomerRequirementUsecase: sl(),
        dashboardUsecase: sl(),
        getCommodityListUsecase: sl(),
        getAllListUsecase: sl(),
        postVendorStockRequirementUsecase: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton<GetDashboardUsecase>(
      () => GetDashboardUsecase(dasboardRepository: sl()));
  sl.registerLazySingleton<AddCustomerRequirementUsecase>(
      () => AddCustomerRequirementUsecase(dasboardRepository: sl()));
  sl.registerLazySingleton<PostVendorStockRequirementUsecase>(
      () => PostVendorStockRequirementUsecase(dasboardRepository: sl()));
  sl.registerLazySingleton<GetCommodityListUsecase>(
      () => GetCommodityListUsecase(dasboardRepository: sl()));
  sl.registerLazySingleton<GetAllListUsecase>(
      () => GetAllListUsecase(dasboardRepository: sl()));

  //! Repository
  sl.registerLazySingleton<DashboardRepository>(() => DashboardRepositoryImpl(
        dashboardRemoteDataSource: sl(),
      ));

  //! Data Sources
  sl.registerLazySingleton<DashboardRemoteDataSource>(
      () => DashboardRemoteDataSourceImpl(apiConsumer: sl()));
}
