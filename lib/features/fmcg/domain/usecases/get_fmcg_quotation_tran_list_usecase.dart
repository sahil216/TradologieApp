import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_tran_item.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class QuotationTranListParams extends Equatable {
  final String token;
  final String deviceId;
  final int quotationId;

  const QuotationTranListParams({
    required this.token,
    required this.deviceId,
    required this.quotationId,
  });

  Map<String, dynamic> toJson() => {
        'Token': token,
        'DeviceID': deviceId,
        'QuotationID': quotationId,
      };

  @override
  List<Object?> get props => [token, deviceId, quotationId];
}

class GetFmcgQuotationTranListUsecase
    implements UseCase<List<FmcgQuotationTranItem>, QuotationTranListParams> {
  final ChatRepository chatRepository;

  GetFmcgQuotationTranListUsecase({required this.chatRepository});

  @override
  Future<Either<Failure, List<FmcgQuotationTranItem>>> call(
          QuotationTranListParams params) =>
      chatRepository.getFmcgQuotationTranList(params);
}
