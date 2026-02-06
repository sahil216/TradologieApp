import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/webview/presentation/cubit/webview_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<WebViewCubit>(() => WebViewCubit());

  //! Use cases
  // sl.registerLazySingleton<RequestOtpUsecase>(
  //     () => RequestOtpUsecase(authenticationRepository: sl()));

  //! Repository
  // sl.registerLazySingleton<AuthenticationRepository>(
  //     () => AuthenticationRepositoryImpl(
  //           authenticationRemoteDataSource: sl(),
  //           sharedPreferences: sl(),
  //         ));

  //! Data Sources
  // sl.registerLazySingleton<AuthenticationRemoteDataSource>(
  //     () => AuthenticationRemoteDataSourceImpl(apiConsumer: sl()));
}
