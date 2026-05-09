import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_products_list.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class GetProductsListUsecase
    implements UseCase<List<GetProductsList>, GetProductsListParams> {
  final ChatRepository chatRepository;

  GetProductsListUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, List<GetProductsList>>> call(
          GetProductsListParams params) =>
      chatRepository.getProductsList(params);
}

class GetProductsListParams {
  final String token;
  final String deviceId;
  final String brandId;
  final String buyerId;

  GetProductsListParams({
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
