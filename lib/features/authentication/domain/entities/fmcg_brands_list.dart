import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class FmcgBrandsList extends Equatable {
  final int? brandId;
  final String? brandName;
  final String? localInternalPath;
  final String? brandNameUrl;
  final String? brandAltText;
  final dynamic imageExtension;
  final String? catalogUrl;
  final String? priceListUrl;
  final String? brandDescription;
  final String? brandImageExtension;
  final String? brandLargeDescription;
  final String? brandCompany;

  const FmcgBrandsList({
    this.brandId,
    this.brandName,
    this.localInternalPath,
    this.brandNameUrl,
    this.brandAltText,
    this.imageExtension,
    this.catalogUrl,
    this.priceListUrl,
    this.brandDescription,
    this.brandImageExtension,
    this.brandLargeDescription,
    this.brandCompany,
  });

  @override
  List<Object?> get props => [
        brandId,
        brandName,
        localInternalPath,
        brandNameUrl,
        brandAltText,
        imageExtension,
        catalogUrl,
        priceListUrl,
        brandDescription,
        brandImageExtension,
        brandLargeDescription,
        brandCompany,
      ];
}
