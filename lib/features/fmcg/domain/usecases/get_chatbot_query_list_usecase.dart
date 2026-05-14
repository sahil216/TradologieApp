import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_query_list_item.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class ChatbotQueryListParams extends Equatable {
  final String token;
  final String deviceId;
  final int userId;
  final int indexNo;

  const ChatbotQueryListParams({
    required this.token,
    required this.deviceId,
    required this.userId,
    required this.indexNo,
  });

  Map<String, dynamic> toJson() => {
        'Token': token,
        'DeviceID': deviceId,
        'UserID': userId,
        'IndexNo': indexNo,
      };

  @override
  List<Object?> get props => [token, deviceId, userId, indexNo];
}

class GetChatbotQueryListUsecase
    implements UseCase<ChatbotQueryListResult, ChatbotQueryListParams> {
  final ChatRepository chatRepository;

  GetChatbotQueryListUsecase({required this.chatRepository});

  @override
  Future<Either<Failure, ChatbotQueryListResult>> call(
          ChatbotQueryListParams params) =>
      chatRepository.getChatbotQueryList(params);
}
