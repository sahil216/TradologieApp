import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/buyer_quotation_item.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class GetBuyerQuotationListUsecase
    implements UseCase<List<BuyerQuotationItem>, GetBuyerQuotationListParams> {
  final ChatRepository chatRepository;

  GetBuyerQuotationListUsecase({required this.chatRepository});

  @override
  Future<Either<Failure, List<BuyerQuotationItem>>> call(
          GetBuyerQuotationListParams params) =>
      chatRepository.getBuyerQuotationList(params);
}

class GetBuyerQuotationListParams {
  final String token;
  final String deviceId;
  final int brandId;
  final int buyerId;

  GetBuyerQuotationListParams({
    required this.token,
    required this.deviceId,
    required this.brandId,
    required this.buyerId,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "DeviceID": deviceId,
        "BrandID": brandId,
        "BuyerID": buyerId,
      };
}

