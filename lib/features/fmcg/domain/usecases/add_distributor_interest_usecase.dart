import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class AddDistributorInterestParams {
  final String token;
  final String deviceID;
  final String sellerID;
  final String distributorID;

  AddDistributorInterestParams({
    required this.token,
    required this.deviceID,
    required this.sellerID,
    required this.distributorID,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "DeviceID": deviceID,
        "SellerID": sellerID,
        "DistributorID": distributorID,
      };
}

class AddDistributorInterestUsecase
    implements UseCase<bool, AddDistributorInterestParams> {
  final ChatRepository chatRepository;

  AddDistributorInterestUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, bool>> call(AddDistributorInterestParams params) =>
      chatRepository.addDistributorInterest(params);
}
