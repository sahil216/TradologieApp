import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_initial_chat_id.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class GetInitialChatIdUsecase
    implements UseCase<GetInitialChatId, GetInitialChatIdParams> {
  final ChatRepository chatRepository;

  GetInitialChatIdUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, GetInitialChatId>> call(
          GetInitialChatIdParams params) =>
      chatRepository.getInitialChatId(params);
}

class GetInitialChatIdParams {
  final String token;
  final String deviceId;
  final String buyerId;
  final String brandId;

  GetInitialChatIdParams({
    required this.token,
    required this.deviceId,
    required this.buyerId,
    required this.brandId,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "DeviceID": deviceId,
        "BuyerID": buyerId,
        "BrandID": brandId,
      };
}
