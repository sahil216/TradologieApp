import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_buyer_brands_list.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_get_seller_profile.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_seller_document_detail.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_buyer_brand_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/add_distributor_interest_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_buyer_brands_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_distributor_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_seller_profile_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_documents_usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/update_seller_profile_usecase.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatListUsecase chatListUsecase;
  final ChatDataUsecase chatDataUsecase;
  final GetDistributorListUsecase getDistributorListUsecase;
  final GetSellerDocumentsUsecase getSellerDocumentsUsecase;
  final GetSellerProfileUsecase getSellerProfileUsecase;
  final UpdateSellerProfileUsecase updateSellerProfileUsecase;
  final UpdateSellerDocumentsUsecase updateSellerDocumentsUsecase;
  final GetBuyerBrandsListUsecase getBuyerBrandsListUsecase;
  final AddDistributorInterestUsecase addDistributorInterestUsecase;
  final AddBuyerBrandInterestUsecase addBuyerBrandInterestUsecase;

  ChatCubit(
      {required this.chatListUsecase,
      required this.chatDataUsecase,
      required this.getDistributorListUsecase,
      required this.getSellerDocumentsUsecase,
      required this.getSellerProfileUsecase,
      required this.updateSellerProfileUsecase,
      required this.updateSellerDocumentsUsecase,
      required this.getBuyerBrandsListUsecase,
      required this.addDistributorInterestUsecase,
      required this.addBuyerBrandInterestUsecase})
      : super(ChatInitial());

  Future<void> getChatList(ChatListParams params) async {
    emit(GetChatListIsLoading());
    Either<Failure, List<ChatList>> response = await chatListUsecase(params);
    emit(response.fold(
      (failure) => GetChatListError(failure: failure),
      (res) => GetChatListSuccess(data: res),
    ));
  }

  Future<void> chatData(ChatDataParams params) async {
    emit(ChatDataIsLoading());
    Either<Failure, List<ChatData>> response = await chatDataUsecase(params);
    emit(response.fold(
      (failure) => ChatDataError(failure: failure),
      (res) => ChatDataSuccess(data: res),
    ));
  }

  Future<void> getDistributorList(NoParams params) async {
    emit(DistributorListIsLoading());
    Either<Failure, List<DistributorEnquiryList>> response =
        await getDistributorListUsecase(params);
    emit(response.fold(
      (failure) => DistributorListError(failure: failure),
      (res) => DistributorListSuccess(data: res),
    ));
  }

  Future<void> updateSellerDocuments(UpdateSellerDocumentsParams params) async {
    emit(UpdateSellerDocumentsIsLoading());
    Either<Failure, bool> response = await updateSellerDocumentsUsecase(params);
    emit(response.fold(
      (failure) => UpdateSellerDocumentsError(failure: failure),
      (res) => UpdateSellerDocumentsSuccess(data: res),
    ));
  }

  Future<void> updateSellerProfile(UpdateSellerProfileParams params) async {
    emit(UpdateSellerProfileIsLoading());
    Either<Failure, bool> response = await updateSellerProfileUsecase(params);
    emit(response.fold(
      (failure) => UpdateSellerProfileError(failure: failure),
      (res) => UpdateSellerProfileSuccess(data: res),
    ));
  }

  Future<void> getSellerDocuments(GetSellerDocumentsParams params) async {
    emit(GetSellerDocumentsIsLoading());
    Either<Failure, FmcgSellerDocumentDetail> response =
        await getSellerDocumentsUsecase(params);
    emit(response.fold(
      (failure) => GetSellerDocumentsError(failure: failure),
      (res) => GetSellerDocumentsSuccess(data: res),
    ));
  }

  Future<void> getSellerProfile(GetSellerProfileParams params) async {
    emit(GetSellerProfileIsLoading());
    Either<Failure, FmcgGetSellerProfile> response =
        await getSellerProfileUsecase(params);
    emit(response.fold(
      (failure) => GetSellerProfileError(failure: failure),
      (res) => GetSellerProfileSuccess(data: res),
    ));
  }

  Future<void> getBuyerBrandsList(GetBuyerBrandsListParams params) async {
    emit(GetBuyerBrandsListIsLoading());
    Either<Failure, List<FmcgBuyerBrandsList>> response =
        await getBuyerBrandsListUsecase(params);
    emit(response.fold(
      (failure) => GetBuyerBrandsListError(failure: failure),
      (res) => GetBuyerBrandsListSuccess(data: res),
    ));
  }

  Future<void> addBuyerBrandInterest(AddBuyerBrandInterestParams params) async {
    emit(AddBuyerBrandInterestIsLoading());
    Either<Failure, bool> response = await addBuyerBrandInterestUsecase(params);
    emit(response.fold(
      (failure) => AddBuyerBrandInterestError(failure: failure),
      (res) => AddBuyerBrandInterestSuccess(data: res),
    ));
  }

  Future<void> addDistributorInterest(
      AddDistributorInterestParams params) async {
    emit(AddDistributorInterestIsLoading());
    Either<Failure, bool> response =
        await addDistributorInterestUsecase(params);
    emit(response.fold(
      (failure) => AddDistributorInterestError(failure: failure),
      (res) => AddDistributorInterestSuccess(data: res),
    ));
  }
}
