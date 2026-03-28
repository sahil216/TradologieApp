import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_service_label_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgSellerServiceLabelListUsecase
    implements UseCase<List<FmcgSellerServiceLabelList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgSellerServiceLabelListUsecase({required this.authenticationRepository});
  @override
  Future<Either<Failure, List<FmcgSellerServiceLabelList>>> call(
          NoParams params) =>
      authenticationRepository.fmcgSellerServiceLabelList(params);
}
