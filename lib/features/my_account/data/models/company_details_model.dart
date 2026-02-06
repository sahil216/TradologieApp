import 'package:tradologie_app/features/my_account/domain/entities/company_details.dart';

class CompanyDetailsModel extends CompanyDetails {
  const CompanyDetailsModel({
    super.vendorId,
    super.vendorCode,
    super.vendorName,
    super.vendorShortName,
    super.sellerTimeZone,
    super.companyName,
    super.companyType,
    super.companyPanNo,
    super.companyIec,
    super.countryId,
    super.address,
    super.countryName,
    super.stateId,
    super.stateName,
    super.cityId,
    super.cityName,
    super.registrationStatus,
    super.dateOfIncorporation,
    super.zipCode,
    super.areaId,
  });

  factory CompanyDetailsModel.fromJson(Map<String, dynamic> json) =>
      CompanyDetailsModel(
        vendorId: json["VendorID"],
        vendorCode: json["VendorCode"],
        vendorName: json["VendorName"],
        vendorShortName: json["VendorShortName"],
        sellerTimeZone: json["SellerTimeZone"],
        companyName: json["CompanyName"],
        companyType: json["CompanyType"],
        companyPanNo: json["CompanyPANNo"],
        companyIec: json["CompanyIEC"],
        countryId: json["CountryID"],
        address: json["Address"],
        countryName: json["CountryName"],
        stateId: json["StateID"],
        stateName: json["StateName"],
        cityId: json["CityID"],
        cityName: json["CityName"],
        registrationStatus: json["RegistrationStatus"],
        dateOfIncorporation: json["DateOfIncorporation"],
        zipCode: json["ZipCode"],
        areaId: json["AreaID"],
      );
}
