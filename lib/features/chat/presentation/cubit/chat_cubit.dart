import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/chat/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/chat/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/chat/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/chat/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/chat/domain/usecases/chat_list_usecase.dart';
import 'package:tradologie_app/features/chat/domain/usecases/get_distributor_list_usecase.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatListUsecase chatListUsecase;
  final ChatDataUsecase chatDataUsecase;
  final GetDistributorListUsecase getDistributorListUsecase;

  ChatCubit(
      {required this.chatListUsecase,
      required this.chatDataUsecase,
      required this.getDistributorListUsecase})
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
}
