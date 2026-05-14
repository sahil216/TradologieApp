import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class DeleteQuotationCartUsecase
    implements UseCase<String, DeleteQuotationCartParams> {
  final ChatRepository chatRepository;

  DeleteQuotationCartUsecase({required this.chatRepository});

  @override
  Future<Either<Failure, String>> call(DeleteQuotationCartParams params) =>
      chatRepository.deleteQuotationCart(params);
}

class DeleteQuotationCartParams extends Equatable {
  final String token;
  final String deviceId;
  final int quotationId;

  const DeleteQuotationCartParams({
    required this.token,
    required this.deviceId,
    required this.quotationId,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "DeviceID": deviceId,
        "QuotationID": quotationId,
      };

  @override
  List<Object?> get props => [token, deviceId, quotationId];
}

