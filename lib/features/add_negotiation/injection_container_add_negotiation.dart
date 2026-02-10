import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/add_negotiation/data/datasources/add_negotiation_remote_data_source.dart';
import 'package:tradologie_app/features/add_negotiation/data/repositories/add_negotiation_repository_impl.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_category_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_shortlisted_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/cubit/add_negotiation_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<AddNegotiationCubit>(() => AddNegotiationCubit(
        getCategoryUsecase: sl(),
        addSupplierShortlistUsecase: sl(),
        deleteSupplierShortlistUsecase: sl(),
        getSupplierListUsecase: sl(),
        getSupplierShortlistedUsecase: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton<GetCategoryUsecase>(
      () => GetCategoryUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<AddSupplierShortlistUsecase>(
      () => AddSupplierShortlistUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<DeleteSupplierShortlistUsecase>(
      () => DeleteSupplierShortlistUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<GetSupplierListUsecase>(
      () => GetSupplierListUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<GetSupplierShortlistedUsecase>(
      () => GetSupplierShortlistedUsecase(addNegotiationRepository: sl()));

  //! Repository
  sl.registerLazySingleton<AddNegotiationRepository>(
      () => AddNegotiationRepositoryImpl(
            addNegotiationRemoteDataSource: sl(),
          ));

  //! Data Sources
  sl.registerLazySingleton<AddNegotiationRemoteDataSource>(
      () => AddNegotiationRemoteDataSourceImpl(apiConsumer: sl()));
}
