import 'package:equatable/equatable.dart';

class GetProductsList extends Equatable {
  final int? rowNum;
  final int? categoryId;
  final dynamic categoryName;
  final String? categoryNameUrl;
  final String? categoryDescription;
  final int? productId;
  final String? productName;
  final dynamic productNameUrl;
  final int? productTotalAttributes;
  final int? attributeValue1Id;
  final String? attributeValue1Name;
  final int? attributeValue2Id;
  final String? attributeValue2Name;
  final int? productTranId;
  final int? productImageId;
  final String? productImageUrl;
  final String? coverImage;
  final String? productImageType;
  final dynamic altText;
  final dynamic imageCaption;
  final bool? isAddedForQuotation;

  const GetProductsList({
    this.rowNum,
    this.categoryId,
    this.categoryName,
    this.categoryNameUrl,
    this.categoryDescription,
    this.productId,
    this.productName,
    this.productNameUrl,
    this.productTotalAttributes,
    this.attributeValue1Id,
    this.attributeValue1Name,
    this.attributeValue2Id,
    this.attributeValue2Name,
    this.productTranId,
    this.productImageId,
    this.productImageUrl,
    this.coverImage,
    this.productImageType,
    this.altText,
    this.imageCaption,
    this.isAddedForQuotation,
  });

  GetProductsList copyWith({
    int? rowNum,
    int? categoryId,
    dynamic categoryName,
    String? categoryNameUrl,
    String? categoryDescription,
    int? productId,
    String? productName,
    dynamic productNameUrl,
    int? productTotalAttributes,
    int? attributeValue1Id,
    String? attributeValue1Name,
    int? attributeValue2Id,
    String? attributeValue2Name,
    int? productTranId,
    int? productImageId,
    String? productImageUrl,
    String? coverImage,
    String? productImageType,
    dynamic altText,
    dynamic imageCaption,
    bool? isAddedForQuotation,
  }) {
    return GetProductsList(
      rowNum: rowNum ?? this.rowNum,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      categoryNameUrl: categoryNameUrl ?? this.categoryNameUrl,
      categoryDescription: categoryDescription ?? this.categoryDescription,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productNameUrl: productNameUrl ?? this.productNameUrl,
      productTotalAttributes:
          productTotalAttributes ?? this.productTotalAttributes,
      attributeValue1Id: attributeValue1Id ?? this.attributeValue1Id,
      attributeValue1Name: attributeValue1Name ?? this.attributeValue1Name,
      attributeValue2Id: attributeValue2Id ?? this.attributeValue2Id,
      attributeValue2Name: attributeValue2Name ?? this.attributeValue2Name,
      productTranId: productTranId ?? this.productTranId,
      productImageId: productImageId ?? this.productImageId,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      coverImage: coverImage ?? this.coverImage,
      productImageType: productImageType ?? this.productImageType,
      altText: altText ?? this.altText,
      imageCaption: imageCaption ?? this.imageCaption,
      isAddedForQuotation: isAddedForQuotation ?? this.isAddedForQuotation,
    );
  }

  @override
  List<Object?> get props => [
        rowNum,
        categoryId,
        categoryName,
        categoryNameUrl,
        categoryDescription,
        productId,
        productName,
        productNameUrl,
        productTotalAttributes,
        attributeValue1Id,
        attributeValue1Name,
        attributeValue2Id,
        attributeValue2Name,
        productTranId,
        productImageId,
        productImageUrl,
        coverImage,
        productImageType,
        altText,
        imageCaption,
        isAddedForQuotation,
      ];
}
