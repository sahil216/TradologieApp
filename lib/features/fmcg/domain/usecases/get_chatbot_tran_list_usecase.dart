import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chatbot_tran_message.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class ChatbotTranListParams extends Equatable {
  final String token;
  final String deviceId;
  final int chatMainId;

  const ChatbotTranListParams({
    required this.token,
    required this.deviceId,
    required this.chatMainId,
  });

  Map<String, dynamic> toJson() => {
        'Token': token,
        'DeviceID': deviceId,
        'ChatMainID': chatMainId,
      };

  @override
  List<Object?> get props => [token, deviceId, chatMainId];
}

class GetChatbotTranListUsecase
    implements UseCase<List<ChatbotTranMessage>, ChatbotTranListParams> {
  final ChatRepository chatRepository;

  GetChatbotTranListUsecase({required this.chatRepository});

  @override
  Future<Either<Failure, List<ChatbotTranMessage>>> call(
          ChatbotTranListParams params) =>
      chatRepository.getChatbotTranList(params);
}
