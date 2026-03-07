import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:tradologie_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:tradologie_app/features/chat/domain/repositories/chat_repositories.dart';
import 'package:tradologie_app/features/chat/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/chat/domain/usecases/chat_list_usecase.dart';
import 'package:tradologie_app/features/chat/presentation/cubit/chat_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<ChatCubit>(() => ChatCubit(
        chatListUsecase: sl(),
        chatDataUsecase: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton<ChatListUsecase>(
      () => ChatListUsecase(chatRepository: sl()));
  sl.registerLazySingleton<ChatDataUsecase>(
      () => ChatDataUsecase(chatRepository: sl()));

  //! Repository
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
        chatRemoteDataSource: sl(),
      ));

  //! Data Sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(apiConsumer: sl()));
}
