import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class AddQuotationCartUsecase
    implements UseCase<String, AddQuotationCartParams> {
  final ChatRepository chatRepository;

  AddQuotationCartUsecase({required this.chatRepository});

  @override
  Future<Either<Failure, String>> call(AddQuotationCartParams params) =>
      chatRepository.addQuotationCart(params);
}

class AddQuotationCartParams {
  final String token;
  final String deviceId;
  final int productId;
  final int brandId;
  final int attributeValue1Id;
  final int attributeValue2Id;
  final int productTranId;
  final int buyerId;

  AddQuotationCartParams({
    required this.token,
    required this.deviceId,
    required this.productId,
    required this.brandId,
    required this.attributeValue1Id,
    required this.attributeValue2Id,
    required this.productTranId,
    required this.buyerId,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "DeviceID": deviceId,
        "ProductID": productId,
        "BrandID": brandId,
        "AttributeValue1ID": attributeValue1Id,
        "AttributeValue2ID": attributeValue2Id,
        "ProductTranID": productTranId,
        "BuyerID": buyerId,
      };
}

