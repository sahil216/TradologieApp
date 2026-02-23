import 'package:equatable/equatable.dart';

class GetVendorStockList extends Equatable {
  final int? requirementId;
  final int? commodityId;
  final String? commodityName;
  final int? subCommodityId;
  final String? subCommodityName;
  final int? attribute1Id;
  final String? attribute1Type;
  final int? attribute2Id;
  final String? attribute2Type;
  final String? attribute1Value;
  final String? attribute2Value;
  final int? quantity;
  final String? quantityUnit;
  final String? locations;
  final String? remarks;
  final int? vendorId;
  final String? vendorName;
  final String? countryCode;
  final String? mobileNo;
  final String? email;
  final String? insertedDate;

  const GetVendorStockList({
    this.requirementId,
    this.commodityId,
    this.commodityName,
    this.subCommodityId,
    this.subCommodityName,
    this.attribute1Id,
    this.attribute1Type,
    this.attribute2Id,
    this.attribute2Type,
    this.attribute1Value,
    this.attribute2Value,
    this.quantity,
    this.quantityUnit,
    this.locations,
    this.remarks,
    this.vendorId,
    this.vendorName,
    this.countryCode,
    this.mobileNo,
    this.email,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [
        requirementId,
        commodityId,
        commodityName,
        subCommodityId,
        subCommodityName,
        attribute1Id,
        attribute1Type,
        attribute2Id,
        attribute2Type,
        attribute1Value,
        attribute2Value,
        quantity,
        quantityUnit,
        locations,
        remarks,
        vendorId,
        vendorName,
        countryCode,
        mobileNo,
        email,
        insertedDate,
      ];
}
