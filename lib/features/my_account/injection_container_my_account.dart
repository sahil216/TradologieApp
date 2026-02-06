import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/my_account/data/datasources/my_account_remote_data_source.dart';
import 'package:tradologie_app/features/my_account/domain/repositories/my_account_repository.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/company_details_usecase.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/save_information_usecase.dart';
import 'package:tradologie_app/features/my_account/domain/usecases/save_login_control_usecase.dart';
import 'package:tradologie_app/features/my_account/presentation/cubit/my_account_cubit.dart';

import 'data/repositories/my_account_repositories_impl.dart';
import 'domain/usecases/get_information_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<MyAccountCubit>(() => MyAccountCubit(
        saveInformationUsecase: sl(),
        getInformationUsecase: sl(),
        saveLoginControlUsecase: sl(),
        companyDetailsUsecase: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton<SaveInformationUsecase>(
      () => SaveInformationUsecase(myAccountRepository: sl()));

  sl.registerLazySingleton<SaveLoginControlUsecase>(
      () => SaveLoginControlUsecase(myAccountRepository: sl()));

  sl.registerLazySingleton<GetInformationUsecase>(
      () => GetInformationUsecase(myAccountRepository: sl()));
  sl.registerLazySingleton<CompanyDetailsUsecase>(
      () => CompanyDetailsUsecase(myAccountRepository: sl()));

  //! Repository
  sl.registerLazySingleton<MyAccountRepository>(() => MyAccountRepositoryImpl(
        myAccountRemoteDataSource: sl(),
      ));

  //! Data Sources
  sl.registerLazySingleton<MyAccountRemoteDataSource>(
      () => MyAccountRemoteDataSourceImpl(apiConsumer: sl()));
}
