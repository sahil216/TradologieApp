import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class AddSupplierShortlistUsecase
    implements UseCase<bool, AddShortListSupplierParams> {
  final AddNegotiationRepository addNegotiationRepository;

  AddSupplierShortlistUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, bool>> call(AddShortListSupplierParams params) =>
      addNegotiationRepository.addSupplierShortList(params);
}

class AddShortListSupplierParams extends Equatable {
  final String token;
  final String customerID;
  final String userID;
  final String supplierID;
  final String groupID;

  const AddShortListSupplierParams({
    required this.token,
    required this.customerID,
    required this.userID,
    required this.supplierID,
    required this.groupID,
  });
  @override
  List<Object?> get props => [token, customerID, userID, supplierID, groupID];

  Map<String, dynamic> toJson() => {
        "Token": token,
        "CustomerID": customerID,
        "UserID": userID,
        "SupplierID": supplierID,
        "GroupID": groupID,
      };
}
