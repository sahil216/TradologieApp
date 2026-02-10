import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/notifications_service.dart';
import 'app_lifecycle_observer.dart';
import 'bloc_observer.dart';
import 'config/routes/navigation_service.dart';
import 'core/api/api_consumer.dart';
import 'core/api/app_interceptors.dart';
import 'core/api/dio_consumer.dart';
import 'core/local_storge/local_consumer.dart';
import 'core/network/netwok_info.dart';

import '../../../../features/authentication/injection_container_authentication.dart'
    as di_authentication;
import '../../../../features/app/injection_container_app.dart' as di_app;
import '../../../../features/webview/injection_container_webview.dart'
    as di_webview;

import 'features/dashboard/injection_container_dashboard.dart' as di_dashboard;

import 'features/negotiation/injection_container_negotiation.dart'
    as di_negotiation;
import 'features/add_negotiation/injection_container_add_negotiation.dart'
    as di_add_negotiation;

import 'features/my_account/injection_container_my_account.dart'
    as di_my_account;

import 'features/notification/injection_container_notification.dart'
    as di_notification;

import 'core/utils/app_strings.dart';
import 'core/utils/constants.dart';

final sl = GetIt.instance;

Future<void> init(Future<void> Function(RemoteMessage) handler) async {
  SecureStorageService secureStorage = SecureStorageService();
  //! init
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }
  AppLifecycleObserver().startObserving();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //! Core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));
  sl.registerLazySingleton<ApiConsumer>(
      () => DioConsumer(client: sl(), networkInfo: sl()));
  sl.registerLazySingleton<LocalConsumer>(() => LocalConsumerImpl(
      sharedPreferences: sl(), applicationDocumentsDirectory: sl()));

  //! Config
  sl.registerLazySingleton(() => NavigationService());

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  final packageInfo = await PackageInfo.fromPlatform();
  sl.registerLazySingleton(() => packageInfo);
  sl.registerLazySingleton(() => AppIntercepters(
        sharedPreferences: sl(),
        navigationService: sl(),
        packageInfo: sl(),
      ));

  final notificationService = FirebaseNotificationService(
    navigationService: sl(),
    handler: handler,
  );
  sl.registerLazySingleton(() => notificationService);

  await notificationService.init();

  sl.registerLazySingleton(() => LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true));
  sl.registerLazySingleton(() => InternetConnectionChecker.createInstance());
  sl.registerLazySingleton(() => Dio());

  //! di
  await di_app.init();
  await di_authentication.init();
  await di_webview.init();
  await di_dashboard.init();
  await di_negotiation.init();
  await di_my_account.init();
  await di_notification.init();
  await di_add_negotiation.init();

  //! init variable
  Constants.isLogin = bool.tryParse(
          await secureStorage.read(AppStrings.appSession) ?? "false") ??
      false;

  Constants.isBuyer =
      bool.tryParse(await secureStorage.read(AppStrings.isBuyer) ?? "false") ??
          false;

  Constants.name = Constants.isBuyer == true
      ? await secureStorage.read(AppStrings.customerName) ?? ""
      : await secureStorage.read(AppStrings.vendorName) ?? "";
}
