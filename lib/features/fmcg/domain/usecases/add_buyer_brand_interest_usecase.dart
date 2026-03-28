import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class AddBuyerBrandInterestParams {
  final String token;
  final String deviceID;
  final String brandID;
  final String distributorID;

  AddBuyerBrandInterestParams({
    required this.token,
    required this.deviceID,
    required this.brandID,
    required this.distributorID,
  });
  Map<String, dynamic> toJson() => {
        "Token": token,
        "DeviceID": deviceID,
        "BrandID": brandID,
        "DistributorID": distributorID,
      };
}

class AddBuyerBrandInterestUsecase
    implements UseCase<bool, AddBuyerBrandInterestParams> {
  final ChatRepository chatRepository;

  AddBuyerBrandInterestUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, bool>> call(AddBuyerBrandInterestParams params) =>
      chatRepository.addBuyerBrandInterest(params);
}
