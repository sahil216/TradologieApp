import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/app/domain/usecases/check_force_update_usecase.dart';

import 'data/datasources/app_local_data_source.dart';
import 'data/repositories/app_repository_impl.dart';
import 'domain/repositories/app_repository.dart';
import 'domain/usecases/change_lang.dart';
import 'presentation/cubit/app_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<AppCubit>(() => AppCubit(
        changeLangUseCase: sl(),
        checkForceUpdateUsecase: sl(),
        networkInfo: sl(),
      ));

  //! Use cases

  sl.registerLazySingleton<ChangeLangUseCase>(
      () => ChangeLangUseCase(appRepository: sl()));

  sl.registerLazySingleton<CheckForceUpdateUsecase>(
      () => CheckForceUpdateUsecase(appRepository: sl()));

  //! Repository
  sl.registerLazySingleton<AppRepository>(
      () => AppRepositoryImpl(appLocalDataSource: sl()));

  //! Data Sources
  sl.registerLazySingleton<AppLocalDataSource>(
      () => AppLocalDataSourceImpl(sharedPreferences: sl(), apiConsumer: sl()));
}
