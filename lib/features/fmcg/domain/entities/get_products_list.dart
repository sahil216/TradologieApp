import 'package:equatable/equatable.dart';

class GetProductsList extends Equatable {
  final int? categoryId;
  final dynamic categoryName;
  final int? productId;
  final String? productName;
  final dynamic productNameUrl;
  final int? productImageId;
  final String? productImageUrl;
  final dynamic altText;
  final dynamic imageCaption;

  const GetProductsList({
    this.categoryId,
    this.categoryName,
    this.productId,
    this.productName,
    this.productNameUrl,
    this.productImageId,
    this.productImageUrl,
    this.altText,
    this.imageCaption,
  });

  @override
  List<Object?> get props => [
        categoryId,
        categoryName,
        productId,
        productName,
        productNameUrl,
        productImageId,
        productImageUrl,
        altText,
        imageCaption,
      ];
}
