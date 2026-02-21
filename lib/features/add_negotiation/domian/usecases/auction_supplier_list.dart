import 'package:equatable/equatable.dart';

import 'package:dartz/dartz.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/usecases/usecase.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/add_auction_supplier_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/auction_item_list_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/repositories/add_negotiation_repository.dart';
import 'package:tradologie_app/features/add_negotiation/domian/usecases/auction_item_list_usecase.dart';

class AuctionSupplierListUsecase
    implements UseCase<List<AddAuctionSupplierListData>, String> {
  final AddNegotiationRepository addNegotiationRepository;

  AuctionSupplierListUsecase({required this.addNegotiationRepository});
  @override
  Future<Either<Failure, List<AddAuctionSupplierListData>>> call(
          String params) =>
      addNegotiationRepository.auctionSupplierList(params);
}
