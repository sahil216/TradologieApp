import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_exporting_products_list.dart';
import 'package:tradologie_app/features/authentication/domain/repositories/authentication_repository.dart';

class FmcgSellerExportingProductsListUsecase
    implements UseCase<List<FmcgSellerExportingProductsList>, NoParams> {
  final AuthenticationRepository authenticationRepository;

  FmcgSellerExportingProductsListUsecase(
      {required this.authenticationRepository});
  @override
  Future<Either<Failure, List<FmcgSellerExportingProductsList>>> call(
          NoParams params) =>
      authenticationRepository.fmcgSellerExportingProductsList(params);
}
