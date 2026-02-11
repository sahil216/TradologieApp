import 'package:equatable/equatable.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/currency_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/customer_address_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/inspection_agency_list.dart';

class CreateAuctionDetail extends Equatable {
  final String? auctionGroup;
  final String? auctionCode;
  final int? minAuctionQty;
  final int? minDaysDiffDeliveryLastDate;
  final int? maxDaysDiffDeliveryLastDate;
  final List<InspectionAgencyList>? inspectionAgencyList;
  final List<CustomerAddressList>? customerAddressList;
  final List<CurrencyList>? currencyList;

  const CreateAuctionDetail({
    this.auctionGroup,
    this.auctionCode,
    this.minAuctionQty,
    this.minDaysDiffDeliveryLastDate,
    this.maxDaysDiffDeliveryLastDate,
    this.inspectionAgencyList,
    this.customerAddressList,
    this.currencyList,
  });

  @override
  List<Object?> get props => [
        auctionGroup,
        auctionCode,
        minAuctionQty,
        minDaysDiffDeliveryLastDate,
        maxDaysDiffDeliveryLastDate,
        inspectionAgencyList,
        customerAddressList,
        currencyList,
      ];
}
