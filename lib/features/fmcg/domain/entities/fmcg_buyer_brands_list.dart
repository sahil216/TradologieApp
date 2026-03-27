import 'package:equatable/equatable.dart';

class FmcgBuyerBrandsList extends Equatable {
  final int? brandId;
  final String? brandName;
  final String? brandNameUrl;
  final String? localInternalPath;
  final String? brandImage;
  final String? brandAltText;
  final String? insertedDate;
  final String? updatedDate;
  final String? analyticsUrl;
  final int? totalInterestedDistributors;
  final bool? isInterested;

  const FmcgBuyerBrandsList({
    this.brandId,
    this.brandName,
    this.brandNameUrl,
    this.localInternalPath,
    this.brandImage,
    this.brandAltText,
    this.insertedDate,
    this.updatedDate,
    this.analyticsUrl,
    this.totalInterestedDistributors,
    this.isInterested,
  });

  @override
  List<Object?> get props => [
        brandId,
        brandName,
        brandNameUrl,
        localInternalPath,
        brandImage,
        brandAltText,
        insertedDate,
        updatedDate,
        analyticsUrl,
        totalInterestedDistributors,
        isInterested,
      ];
}
