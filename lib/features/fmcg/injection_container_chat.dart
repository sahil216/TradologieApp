import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/fmcg/data/datasources/chat_remote_data_source.dart';
import 'package:tradologie_app/features/fmcg/data/repositories/chat_repository_impl.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_distributor_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<ChatCubit>(() => ChatCubit(
        chatListUsecase: sl(),
        chatDataUsecase: sl(),
        getDistributorListUsecase: sl(),
        getSellerDocumentsUsecase: sl(),
        getSellerProfileUsecase: sl(),
        updateSellerProfileUsecase: sl(),
        updateSellerDocumentsUsecase: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton<ChatListUsecase>(
      () => ChatListUsecase(chatRepository: sl()));
  sl.registerLazySingleton<ChatDataUsecase>(
      () => ChatDataUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetDistributorListUsecase>(
      () => GetDistributorListUsecase(chatRepository: sl()));

  sl.registerLazySingleton<GetSellerDocumentsUsecase>(
      () => GetSellerDocumentsUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetSellerProfileUsecase>(
      () => GetSellerProfileUsecase(chatRepository: sl()));
  sl.registerLazySingleton<UpdateSellerProfileUsecase>(
      () => UpdateSellerProfileUsecase(chatRepository: sl()));
  sl.registerLazySingleton<UpdateSellerDocumentsUsecase>(
      () => UpdateSellerDocumentsUsecase(chatRepository: sl()));

  //! Repository
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
        chatRemoteDataSource: sl(),
      ));

  //! Data Sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(apiConsumer: sl()));
}
