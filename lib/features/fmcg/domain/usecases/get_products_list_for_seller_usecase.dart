import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_products_list.dart';
import 'package:tradologie_app/features/fmcg/domain/repositories/chat_repositories.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_products_list_usecase.dart';

class GetProductsListForSellerUsecase
    implements UseCase<List<GetProductsList>, GetProductsListParams> {
  final ChatRepository chatRepository;

  GetProductsListForSellerUsecase({required this.chatRepository});

  @override
  Future<Either<Failure, List<GetProductsList>>> call(
          GetProductsListParams params) =>
      chatRepository.getProductsListForSeller(params);
}

