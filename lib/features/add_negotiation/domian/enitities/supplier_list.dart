import 'package:equatable/equatable.dart';

class SupplierList extends Equatable {
  final int? vendorId;
  final String? vendorUserId;
  final String? vendorCode;
  final String? vendorShortName;
  final String? vendorLogo;
  final String? webLink;
  final String? webUrl;
  final String? vendorName;
  final String? fileType;
  final String? companyName;
  final String? vendorDescription;
  final String? vendorDocumentType;
  final int? priority;
  final String? annualTurnOver;
  final String? yearOfEstablishment;
  final String? certifications;
  final String? areaOfOperation;
  final String? manufacturer;
  final int? membershipTypeId;
  final String? trader;
  final String? verified;
  final String? rating;
  final int? countryId;
  final String? countryName;
  final int? shortlistId;
  final String? membershipTypeImage;

  const SupplierList({
    this.vendorId,
    this.vendorUserId,
    this.vendorCode,
    this.vendorShortName,
    this.vendorLogo,
    this.webLink,
    this.webUrl,
    this.vendorName,
    this.fileType,
    this.companyName,
    this.vendorDescription,
    this.vendorDocumentType,
    this.priority,
    this.annualTurnOver,
    this.yearOfEstablishment,
    this.certifications,
    this.areaOfOperation,
    this.manufacturer,
    this.membershipTypeId,
    this.trader,
    this.verified,
    this.rating,
    this.countryId,
    this.countryName,
    this.shortlistId,
    this.membershipTypeImage,
  });

  @override
  List<Object?> get props => [
        vendorId,
        vendorUserId,
        vendorCode,
        vendorShortName,
        vendorLogo,
        webLink,
        webUrl,
        vendorName,
        fileType,
        companyName,
        vendorDescription,
        vendorDocumentType,
        priority,
        annualTurnOver,
        yearOfEstablishment,
        certifications,
        areaOfOperation,
        manufacturer,
        membershipTypeId,
        trader,
        verified,
        rating,
        countryId,
        countryName,
        shortlistId,
        membershipTypeImage,
      ];
}
