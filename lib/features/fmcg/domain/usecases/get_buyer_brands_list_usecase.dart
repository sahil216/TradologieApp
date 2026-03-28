import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_buyer_brands_list.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class GetBuyerBrandsListParams {
  final String token;
  final String deviceID;
  final String distributorID;
  final String searchText;

  GetBuyerBrandsListParams({
    required this.token,
    required this.deviceID,
    required this.distributorID,
    required this.searchText,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "DeviceID": deviceID,
        "DistributorID": distributorID,
        "SearchText": searchText,
      };
}

class GetBuyerBrandsListUsecase
    implements UseCase<List<FmcgBuyerBrandsList>, GetBuyerBrandsListParams> {
  final ChatRepository chatRepository;

  GetBuyerBrandsListUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, List<FmcgBuyerBrandsList>>> call(
          GetBuyerBrandsListParams params) =>
      chatRepository.getBuyerBrandsList(params);
}
