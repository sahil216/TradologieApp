import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/add_auction_supplier_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';

class AddAuctionSupplierListUsecase
    implements UseCase<List<AddAuctionSupplierListData>, NoParams> {
  final AddNegotiationRepository addNegotiationRepository;

  AddAuctionSupplierListUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, List<AddAuctionSupplierListData>>> call(
          NoParams params) =>
      addNegotiationRepository.addAuctionSupplierList(params);
}
