import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/fmcg_quotation_list_item.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_chatbot_query_list_usecase.dart';

class GetFmcgQuotationListUsecase
    implements UseCase<FmcgQuotationListResult, ChatbotQueryListParams> {
  final ChatRepository chatRepository;

  GetFmcgQuotationListUsecase({required this.chatRepository});

  @override
  Future<Either<Failure, FmcgQuotationListResult>> call(
          ChatbotQueryListParams params) =>
      chatRepository.getFmcgQuotationList(params);
}
