import 'package:equatable/equatable.dart';

class GetInformationDetail extends Equatable {
  final int? vendorId;
  final String? vendorName;
  final String? vendorCode;
  final String? vendorDescription;
  final String? vendorLogoImageUrl;
  final String? vendorDocumentUrl;
  final String? vendorDocument;
  final String? vendorDocumentExt;
  final String? annualTurnOver;
  final String? yearOfEstablishment;
  final String? certifications;
  final String? areaOfOperation;
  final String? rating;
  final String? priority;
  final dynamic isActive;

  const GetInformationDetail({
    this.vendorId,
    this.vendorName,
    this.vendorCode,
    this.vendorDescription,
    this.vendorLogoImageUrl,
    this.vendorDocumentUrl,
    this.vendorDocument,
    this.vendorDocumentExt,
    this.annualTurnOver,
    this.yearOfEstablishment,
    this.certifications,
    this.areaOfOperation,
    this.rating,
    this.priority,
    this.isActive,
  });

  @override
  List<Object?> get props => [
        vendorId,
        vendorName,
        vendorCode,
        vendorDescription,
        vendorLogoImageUrl,
        vendorDocumentUrl,
        vendorDocument,
        vendorDocumentExt,
        annualTurnOver,
        yearOfEstablishment,
        certifications,
        areaOfOperation,
        rating,
        priority,
        isActive,
      ];
}
