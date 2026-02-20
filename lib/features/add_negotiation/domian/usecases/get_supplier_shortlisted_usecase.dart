import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/get_supplier_list_usecase.dart';

class GetSupplierShortlistedUsecase
    implements UseCase<GetSupplierData, SupplierListParams> {
  final AddNegotiationRepository addNegotiationRepository;

  GetSupplierShortlistedUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, GetSupplierData>> call(SupplierListParams params) =>
      addNegotiationRepository.getSupplierShortlisted(params);
}
