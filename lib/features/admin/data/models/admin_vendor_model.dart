import '../../domain/entities/admin_vendor.dart';

class AdminVendorModel extends AdminVendor {
  const AdminVendorModel({
    required super.vendorId,
    required super.vendorCode,
    required super.vendorName,
    required super.mobileNo,
    required super.countryName,
    required super.emailId,
    required super.registrationDate,
    super.vendorImage,
    super.lastChatDate,
  });

  factory AdminVendorModel.fromVendorListJson(Map<String, dynamic> json) =>
      AdminVendorModel(
        vendorId: json['VendorID'] as int? ?? 0,
        vendorCode: json['VendorCode']?.toString() ?? '',
        vendorName: json['VendorName']?.toString() ?? '',
        mobileNo: json['MobileNo']?.toString() ?? '',
        countryName: json['CountryName']?.toString() ?? '',
        emailId: json['EmailID']?.toString() ?? '',
        registrationDate: json['RegistrationDate']?.toString() ?? '',
      );

  factory AdminVendorModel.fromChatListJson(Map<String, dynamic> json) =>
      AdminVendorModel(
        vendorId: json['VendorID'] as int? ?? 0,
        vendorCode: json['VendorCode']?.toString() ?? '',
        vendorName: json['VendorName']?.toString() ?? '',
        mobileNo: '',
        countryName: '',
        emailId: '',
        registrationDate: '',
        vendorImage: json['VendorImage']?.toString() ?? '',
        lastChatDate: json['LastChatDate']?.toString() ?? '',
      );
}
