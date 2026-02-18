import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/add_negotiation/data/datasources/add_negotiation_remote_data_source.dart';
import 'package:tradologie_app/features/add_negotiation/data/repositories/add_negotiation_repository_impl.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_item_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_supplier_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_auction_supplier_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/add_update_auction_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_detail_for_edit_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_item_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/create_auction_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_auction_item_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/delete_supplier_shortlist_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_category_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_list_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_shortlisted_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/gradle_file_upload_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/packing_image_upload_usecase.dart';
import 'package:tradologie_app/features/add_negotiation/presentation/cubit/add_negotiation_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Blocs
  sl.registerFactory<AddNegotiationCubit>(() => AddNegotiationCubit(
        getCategoryUsecase: sl(),
        addSupplierShortlistUsecase: sl(),
        deleteSupplierShortlistUsecase: sl(),
        getSupplierListUsecase: sl(),
        getSupplierShortlistedUsecase: sl(),
        createAuctionUsecase: sl(),
        auctionItemListUsecase: sl(),
        gradleFileUploadUsecase: sl(),
        packingImageUploadUsecase: sl(),
        addAuctionItemUsecase: sl(),
        addAuctionSupplierUsecase: sl(),
        auctionDetailForEditUsecase: sl(),
        addAuctionSupplierListUsecase: sl(),
        deleteAuctionItemUsecase: sl(),
        addUpdateAuctionUsecase: sl(),
      ));

  //! Use cases
  sl.registerLazySingleton<GetCategoryUsecase>(
      () => GetCategoryUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<AddSupplierShortlistUsecase>(
      () => AddSupplierShortlistUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<DeleteSupplierShortlistUsecase>(
      () => DeleteSupplierShortlistUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<GetSupplierListUsecase>(
      () => GetSupplierListUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<GetSupplierShortlistedUsecase>(
      () => GetSupplierShortlistedUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<CreateAuctionUsecase>(
      () => CreateAuctionUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<AuctionItemListUsecase>(
      () => AuctionItemListUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<GradleFileUploadUsecase>(
      () => GradleFileUploadUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<PackingImageUploadUsecase>(
      () => PackingImageUploadUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<AddAuctionItemUsecase>(
      () => AddAuctionItemUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<AddAuctionSupplierUsecase>(
      () => AddAuctionSupplierUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<AuctionDetailForEditUsecase>(
      () => AuctionDetailForEditUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<AddAuctionSupplierListUsecase>(
      () => AddAuctionSupplierListUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<DeleteAuctionItemUsecase>(
      () => DeleteAuctionItemUsecase(addNegotiationRepository: sl()));
  sl.registerLazySingleton<AddUpdateAuctionUsecase>(
      () => AddUpdateAuctionUsecase(addNegotiationRepository: sl()));

  //! Repository
  sl.registerLazySingleton<AddNegotiationRepository>(
      () => AddNegotiationRepositoryImpl(
            addNegotiationRemoteDataSource: sl(),
          ));

  //! Data Sources
  sl.registerLazySingleton<AddNegotiationRemoteDataSource>(
      () => AddNegotiationRemoteDataSourceImpl(apiConsumer: sl()));
}
