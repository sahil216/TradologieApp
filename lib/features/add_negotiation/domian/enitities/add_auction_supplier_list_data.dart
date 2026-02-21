import 'package:equatable/equatable.dart';

class AddAuctionSupplierListData extends Equatable {
  final String? vendorId;
  final String? vendorShortName;
  final String? vendorName;
  final String? companyName;

  const AddAuctionSupplierListData({
    this.vendorId,
    this.vendorShortName,
    this.vendorName,
    this.companyName,
  });

  @override
  List<Object?> get props =>
      [vendorId, vendorShortName, vendorName, companyName];
}
