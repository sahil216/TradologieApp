import 'package:get_it/get_it.dart';
import 'package:tradologie_app/features/fmcg/data/datasources/chat_remote_data_source.dart';
import 'package:tradologie_app/features/fmcg/data/repositories/chat_repository_impl.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_buyer_brand_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_buyer_quotation_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_distributor_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_quotation_cart_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/delete_quotation_cart_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_buyer_quotation_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_buyer_brands_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_distributor_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_query_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_fmcg_quotation_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_fmcg_quotation_tran_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_file_url_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_initial_chat_id_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_products_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_products_list_for_seller_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/nav_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory<NavigationCubit>(() => NavigationCubit());
  sl.registerFactory<ChatCubit>(() => ChatCubit(
        chatListUsecase: sl(),
        chatDataUsecase: sl(),
        getDistributorListUsecase: sl(),
        getSellerDocumentsUsecase: sl(),
        getSellerProfileUsecase: sl(),
        updateSellerProfileUsecase: sl(),
        updateSellerDocumentsUsecase: sl(),
        getBuyerBrandsListUsecase: sl(),
        addDistributorInterestUsecase: sl(),
        addBuyerBrandInterestUsecase: sl(),
        getFileUrlUsecase: sl(),
        getInitialChatIdUsecase: sl(),
        getProductsListUsecase: sl(),
        getProductsListForSellerUsecase: sl(),
        getChatbotQueryListUsecase: sl(),
        getChatbotTranListUsecase: sl(),
        getFmcgQuotationListUsecase: sl(),
        getFmcgQuotationTranListUsecase: sl(),
        addQuotationCartUsecase: sl(),
        getBuyerQuotationListUsecase: sl(),
        deleteQuotationCartUsecase: sl(),
        addBuyerQuotationUsecase: sl(),
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

  sl.registerLazySingleton<GetBuyerBrandsListUsecase>(
      () => GetBuyerBrandsListUsecase(chatRepository: sl()));

  sl.registerLazySingleton<AddDistributorInterestUsecase>(
      () => AddDistributorInterestUsecase(chatRepository: sl()));
  sl.registerLazySingleton<AddBuyerBrandInterestUsecase>(
      () => AddBuyerBrandInterestUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetFileUrlUsecase>(
      () => GetFileUrlUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetInitialChatIdUsecase>(
      () => GetInitialChatIdUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetProductsListUsecase>(
      () => GetProductsListUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetProductsListForSellerUsecase>(
      () => GetProductsListForSellerUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetChatbotQueryListUsecase>(
      () => GetChatbotQueryListUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetChatbotTranListUsecase>(
      () => GetChatbotTranListUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetFmcgQuotationListUsecase>(
      () => GetFmcgQuotationListUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetFmcgQuotationTranListUsecase>(
      () => GetFmcgQuotationTranListUsecase(chatRepository: sl()));
  sl.registerLazySingleton<AddQuotationCartUsecase>(
      () => AddQuotationCartUsecase(chatRepository: sl()));
  sl.registerLazySingleton<GetBuyerQuotationListUsecase>(
      () => GetBuyerQuotationListUsecase(chatRepository: sl()));
  sl.registerLazySingleton<DeleteQuotationCartUsecase>(
      () => DeleteQuotationCartUsecase(chatRepository: sl()));
  sl.registerLazySingleton<AddBuyerQuotationUsecase>(
      () => AddBuyerQuotationUsecase(chatRepository: sl()));

  //! Repository
  sl.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(
        chatRemoteDataSource: sl(),
      ));

  //! Data Sources
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(apiConsumer: sl()));
}
