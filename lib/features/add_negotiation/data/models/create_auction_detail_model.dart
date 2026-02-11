import 'package:tradologie_app/features/add_negotiation/data/models/currency_list_model.dart';
import 'package:tradologie_app/features/add_negotiation/data/models/customer_address_list_model.dart';
import 'package:tradologie_app/features/add_negotiation/data/models/inspection_agency_list_model.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/create_auction_detail.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/currency_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/customer_address_list.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/inspection_agency_list.dart';

class CreateAuctionDetailModel extends CreateAuctionDetail {
  const CreateAuctionDetailModel({
    super.auctionGroup,
    super.auctionCode,
    super.minAuctionQty,
    super.minDaysDiffDeliveryLastDate,
    super.maxDaysDiffDeliveryLastDate,
    super.inspectionAgencyList,
    super.customerAddressList,
    super.currencyList,
  });

  factory CreateAuctionDetailModel.fromJson(Map<String, dynamic> json) =>
      CreateAuctionDetailModel(
        auctionGroup: json["AuctionGroup"],
        auctionCode: json["AuctionCode"],
        minAuctionQty: json["MinAuctionQty"],
        minDaysDiffDeliveryLastDate: json["MinDaysDiffDeliveryLastDate"],
        maxDaysDiffDeliveryLastDate: json["MaxDaysDiffDeliveryLastDate"],
        inspectionAgencyList: json["InspectionAgencyList"] == null
            ? []
            : List<InspectionAgencyList>.from(json["InspectionAgencyList"]!
                .map((x) => InspectionAgencyListModel.fromJson(x))),
        customerAddressList: json["CustomerAddressList"] == null
            ? []
            : List<CustomerAddressList>.from(json["CustomerAddressList"]!
                .map((x) => CustomerAddressListModel.fromJson(x))),
        currencyList: json["CurrencyList"] == null
            ? []
            : List<CurrencyList>.from(json["CurrencyList"]!
                .map((x) => CurrencyListModel.fromJson(x))),
      );
}
