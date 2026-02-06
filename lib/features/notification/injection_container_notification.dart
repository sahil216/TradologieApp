import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/notification/data/datasources/notification_remote_data_source.dart';
import 'package:tradologie_app/features/notification/domain/repositories/notification_repository.dart';
import 'package:tradologie_app/features/notification/domain/usecases/notification_usecase.dart';
import 'package:tradologie_app/features/notification/presentation/cubit/notification_cubit.dart';

import 'data/repositories/notification_repository_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<NotificationCubit>(() => NotificationCubit(
        notificationUsecase: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton<NotificationUsecase>(
      () => NotificationUsecase(notificationRepository: sl()));

  //! Repository
  sl.registerLazySingleton<NotificationRepository>(
      () => NotificationRepositoryImpl(
            notificationRemoteDataSource: sl(),
          ));

  //! Data Sources
  sl.registerLazySingleton<NotificationRemoteDataSource>(
      () => NotificationRemoteDataSourceImpl(apiConsumer: sl()));
}
