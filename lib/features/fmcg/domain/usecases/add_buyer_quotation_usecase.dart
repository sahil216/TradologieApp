import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class AddBuyerQuotationUsecase
    implements UseCase<int, AddBuyerQuotationParams> {
  final ChatRepository chatRepository;

  AddBuyerQuotationUsecase({required this.chatRepository});

  @override
  Future<Either<Failure, int>> call(AddBuyerQuotationParams params) =>
      chatRepository.addBuyerQuotation(params);
}

class AddBuyerQuotationParams extends Equatable {
  final String token;
  final String deviceId;
  final int brandId;
  final int buyerId;
  final List<TranQuotationItem> tranQuotation;

  const AddBuyerQuotationParams({
    required this.token,
    required this.deviceId,
    required this.brandId,
    required this.buyerId,
    required this.tranQuotation,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "DeviceID": deviceId,
        "BrandID": brandId,
        "BuyerID": buyerId,
        "TranQuotation": tranQuotation.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props => [token, deviceId, brandId, buyerId, tranQuotation];
}

class TranQuotationItem extends Equatable {
  final int tranId;
  final int quantity;

  const TranQuotationItem({
    required this.tranId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
        "TranID": tranId,
        "Quantity": quantity,
      };

  @override
  List<Object?> get props => [tranId, quantity];
}

