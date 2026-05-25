import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:tradologie_app/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:tradologie_app/features/admin/domain/repositories/admin_repository.dart';
import 'package:tradologie_app/features/admin/domain/usecases/get_admin_vendor_list_usecase.dart';
import 'package:tradologie_app/features/admin/domain/usecases/get_admin_chat_history_usecase.dart';
import 'package:tradologie_app/features/admin/domain/usecases/get_agro_seller_chat_list_usecase.dart';
import 'package:tradologie_app/features/admin/data/admin_signalr_service.dart';
import 'package:tradologie_app/features/admin/presentation/cubit/admin_chat_cubit.dart';
import 'package:tradologie_app/features/admin/presentation/cubit/admin_vendor_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory<AdminChatCubit>(
    () => AdminChatCubit(sl(), sl()),
  );

  sl.registerLazySingleton<GetAdminChatHistoryUsecase>(
    () => GetAdminChatHistoryUsecase(adminRepository: sl()),
  );

  sl.registerLazySingleton<AdminSignalRService>(
    () => AdminSignalRService(),
  );

  sl.registerFactory<AdminVendorCubit>(
    () => AdminVendorCubit(
      getAdminVendorListUsecase: sl(),
      getAgroSellerChatListUsecase: sl(),
    ),
  );

  sl.registerLazySingleton<GetAdminVendorListUsecase>(
    () => GetAdminVendorListUsecase(adminRepository: sl()),
  );

  sl.registerLazySingleton<GetAgroSellerChatListUsecase>(
    () => GetAgroSellerChatListUsecase(adminRepository: sl()),
  );

  sl.registerLazySingleton<AdminRepository>(
    () => AdminRepositoryImpl(adminRemoteDataSource: sl()),
  );

  sl.registerLazySingleton<AdminRemoteDataSource>(
    () => AdminRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
