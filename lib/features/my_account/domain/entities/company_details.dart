import 'package:equatable/equatable.dart';

class CompanyDetails extends Equatable {
  final int? vendorId;
  final String? vendorCode;
  final String? vendorName;
  final String? vendorShortName;
  final String? sellerTimeZone;
  final String? companyName;
  final String? companyType;
  final String? companyPanNo;
  final String? companyIec;
  final int? countryId;
  final String? address;
  final dynamic countryName;
  final int? stateId;
  final dynamic stateName;
  final int? cityId;
  final dynamic cityName;
  final String? registrationStatus;
  final String? dateOfIncorporation;
  final String? zipCode;
  final int? areaId;

  const CompanyDetails({
    this.vendorId,
    this.vendorCode,
    this.vendorName,
    this.vendorShortName,
    this.sellerTimeZone,
    this.companyName,
    this.companyType,
    this.companyPanNo,
    this.companyIec,
    this.countryId,
    this.address,
    this.countryName,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.registrationStatus,
    this.dateOfIncorporation,
    this.zipCode,
    this.areaId,
  });

  @override
  List<Object?> get props => [
        vendorId,
        vendorCode,
        vendorName,
        vendorShortName,
        sellerTimeZone,
        companyName,
        companyType,
        companyPanNo,
        companyIec,
        countryId,
        address,
        countryName,
        stateId,
        stateName,
        cityId,
        cityName,
        registrationStatus,
        dateOfIncorporation,
        zipCode,
        areaId,
      ];
}
