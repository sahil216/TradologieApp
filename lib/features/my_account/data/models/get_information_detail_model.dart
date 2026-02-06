import '../../domain/entities/get_information_detail.dart';

class GetInformationDetailModel extends GetInformationDetail {
  const GetInformationDetailModel({
    super.vendorId,
    super.vendorName,
    super.vendorCode,
    super.vendorDescription,
    super.vendorLogoImageUrl,
    super.vendorDocumentUrl,
    super.vendorDocument,
    super.vendorDocumentExt,
    super.annualTurnOver,
    super.yearOfEstablishment,
    super.certifications,
    super.areaOfOperation,
    super.rating,
    super.priority,
    super.isActive,
  });

  factory GetInformationDetailModel.fromJson(Map<String, dynamic> json) =>
      GetInformationDetailModel(
        vendorId: json["VendorID"],
        vendorName: json["VendorName"],
        vendorCode: json["VendorCode"],
        vendorDescription: json["VendorDescription"],
        vendorLogoImageUrl: json["VendorLogoImageUrl"],
        vendorDocumentUrl: json["VendorDocumentUrl"],
        vendorDocument: json["VendorDocument"],
        vendorDocumentExt: json["VendorDocumentExt"],
        annualTurnOver: json["AnnualTurnOver"],
        yearOfEstablishment: json["YearOfEstablishment"],
        certifications: json["Certifications"],
        areaOfOperation: json["AreaOfOperation"],
        rating: json["Rating"],
        priority: json["Priority"],
        isActive: json["IsActive"],
      );
}
