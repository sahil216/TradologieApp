import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/negotiation/data/datasources/negotiation_remote_data_source.dart';
import 'package:tradologie_app/features/negotiation/data/repositories/negotiation_repository_impl.dart';
import 'package:tradologie_app/features/negotiation/domain/usecases/buyer_negotiation_usecase.dart';
import 'package:tradologie_app/features/negotiation/domain/usecases/get_negotiation_usecase.dart';
import 'package:tradologie_app/features/negotiation/presentation/cubit/negotiation_cubit.dart';

import 'domain/respositories/negotiation_repository.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<NegotiationCubit>(() => NegotiationCubit(
        negotiationUsecase: sl(),
        buyerNegotiationUsecase: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton<GetNegotiationUsecase>(
      () => GetNegotiationUsecase(negotiationRepository: sl()));

  sl.registerLazySingleton<BuyerNegotiationUsecase>(
      () => BuyerNegotiationUsecase(negotiationRepository: sl()));

  //! Repository
  sl.registerLazySingleton<NegotiationRepository>(
      () => NegotiationRepositoryImpl(
            negotiationRemoteDataSource: sl(),
          ));

  //! Data Sources
  sl.registerLazySingleton<NegotiationRemoteDataSource>(
      () => NegotiationRemoteDataSourceImpl(apiConsumer: sl()));
}
