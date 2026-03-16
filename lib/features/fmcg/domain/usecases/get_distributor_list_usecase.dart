import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/distributor_enquiry_list.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';

class GetDistributorListUsecase
    implements UseCase<List<DistributorEnquiryList>, NoParams> {
  final ChatRepository chatRepository;

  GetDistributorListUsecase({required this.chatRepository});
  @override
  Future<Either<Failure, List<DistributorEnquiryList>>> call(NoParams params) =>
      chatRepository.getDistributorList(params);
}
