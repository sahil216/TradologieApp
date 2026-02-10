import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class DeleteSupplierShortlistUsecase
    implements UseCase<bool, RemoveSupplierShortlistParams> {
  final AddNegotiationRepository addNegotiationRepository;

  DeleteSupplierShortlistUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, bool>> call(RemoveSupplierShortlistParams params) =>
      addNegotiationRepository.deleteSupplierShortList(params);
}

class RemoveSupplierShortlistParams extends Equatable {
  final String token;
  final String shortlistID;
  const RemoveSupplierShortlistParams({
    required this.token,
    required this.shortlistID,
  });
  @override
  List<Object?> get props => [token, shortlistID];

  Map<String, dynamic> toJson() => {
        "Token": token,
        "ShortlistID": shortlistID,
      };
}
