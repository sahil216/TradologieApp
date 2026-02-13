import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/buyer_signin_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/delete_account_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/get_country_code_list_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/sign_out_usecase.dart';
import 'data/datasources/authentication_remote_data_source.dart';
import 'data/repositories/authentication_repository_impl.dart';
import 'domain/repositories/authentication_repository.dart';

import '../../features/authentication/presentation/cubit/authentication_cubit.dart';
import 'domain/usecases/buyer_send_otp_usecase.dart';
import 'domain/usecases/buyer_verify_otp_usecase.dart';
import 'domain/usecases/verify_otp_usecase.dart';
import 'domain/usecases/register_usecase.dart';
import 'domain/usecases/send_otp_usecase.dart';
import 'domain/usecases/sign_in_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<AuthenticationCubit>(() => AuthenticationCubit(
        signInUsecase: sl(),
        registerUsecase: sl(),
        sendOtpUsecase: sl(),
        verifyOtpUsecase: sl(),
        buyerSigninUsecase: sl(),
        signOutUsecase: sl(),
        buyerSendOtpUsecase: sl(),
        buyerVerifyOtpUsecase: sl(),
        deleteAccountUsecase: sl(),
        getCountryCodeListUsecase: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton<SendOtpUsecase>(
      () => SendOtpUsecase(authenticationRepository: sl()));
  sl.registerLazySingleton<SignInUsecase>(
      () => SignInUsecase(authenticationRepository: sl()));
  sl.registerLazySingleton<RegisterUsecase>(
      () => RegisterUsecase(authenticationRepository: sl()));
  sl.registerLazySingleton<VerifyOtpUsecase>(
      () => VerifyOtpUsecase(authenticationRepository: sl()));
  sl.registerLazySingleton<BuyerSigninUsecase>(
      () => BuyerSigninUsecase(authenticationRepository: sl()));
  sl.registerLazySingleton<SignOutUsecase>(
      () => SignOutUsecase(authenticationRepository: sl()));
  sl.registerLazySingleton<BuyerSendOtpUsecase>(
      () => BuyerSendOtpUsecase(authenticationRepository: sl()));
  sl.registerLazySingleton<BuyerVerifyOtpUsecase>(
      () => BuyerVerifyOtpUsecase(authenticationRepository: sl()));
  sl.registerLazySingleton<DeleteAccountUsecase>(
      () => DeleteAccountUsecase(authenticationRepository: sl()));
  sl.registerLazySingleton<GetCountryCodeListUsecase>(
      () => GetCountryCodeListUsecase(authenticationRepository: sl()));

  //! Repository
  sl.registerLazySingleton<AuthenticationRepository>(
      () => AuthenticationRepositoryImpl(
            authenticationRemoteDataSource: sl(),
            sharedPreferences: sl(),
          ));

  //! Data Sources
  sl.registerLazySingleton<AuthenticationRemoteDataSource>(
      () => AuthenticationRemoteDataSourceImpl(apiConsumer: sl()));
}
