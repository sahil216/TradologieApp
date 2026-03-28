import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class GetDistributorListUsecase
    implements UseCase<List<DistributorEnquiryList>, GetDistributorListParams> {
  final ChatRepository chatRepository;

  GetDistributorListUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, List<DistributorEnquiryList>>> call(
          GetDistributorListParams params) =>
      chatRepository.getDistributorList(params);
}

class GetDistributorListParams {
  final String token;
  final String deviceID;
  final String category;
  final String searchText;

  GetDistributorListParams({
    required this.token,
    required this.deviceID,
    required this.category,
    required this.searchText,
  });

  Map<String, dynamic> toJson() => {
        "Token": token,
        "DeviceID": deviceID,
        "Category": category,
        "SearchText": searchText,
      };
}
