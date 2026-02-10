import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class GetSupplierListUsecase
    implements UseCase<List<SupplierList>, SupplierListParams> {
  final AddNegotiationRepository addNegotiationRepository;

  GetSupplierListUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, List<SupplierList>>> call(SupplierListParams params) =>
      addNegotiationRepository.getSupplierList(params);
}

class SupplierListParams extends Equatable {
  final String customerId;
  final String groupID;
  const SupplierListParams({required this.customerId, required this.groupID});
  @override
  List<Object?> get props => [customerId, groupID];
}
