import 'package:tradologie_app/features/add_negotiation/domian/enitities/add_auction_supplier_list_data.dart';

class AddAuctionSupplierListDataModel extends AddAuctionSupplierListData {
  const AddAuctionSupplierListDataModel({
    super.vendorId,
    super.vendorShortName,
    super.vendorName,
    super.companyName,
  });

  factory AddAuctionSupplierListDataModel.fromJson(Map<String, dynamic> json) =>
      AddAuctionSupplierListDataModel(
        vendorId: json["VendorID"].toString(),
        vendorShortName: json["VendorShortName"],
        vendorName: json["VendorName"],
        companyName: json["CompanyName"],
      );
}
