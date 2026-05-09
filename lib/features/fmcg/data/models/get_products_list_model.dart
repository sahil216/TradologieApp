import 'package:tradologie_app/features/fmcg/domain/entities/get_products_list.dart';

class GetProductsListModel extends GetProductsList {
  const GetProductsListModel({
    super.rowNum,
    super.categoryId,
    super.categoryName,
    super.categoryNameUrl,
    super.categoryDescription,
    super.productId,
    super.productName,
    super.productNameUrl,
    super.productTotalAttributes,
    super.attributeValue1Id,
    super.attributeValue1Name,
    super.attributeValue2Id,
    super.attributeValue2Name,
    super.productTranId,
    super.productImageId,
    super.productImageUrl,
    super.coverImage,
    super.productImageType,
    super.altText,
    super.imageCaption,
    super.isAddedForQuotation,
  });

  factory GetProductsListModel.fromJson(Map<String, dynamic> json) =>
      GetProductsListModel(
        rowNum: json["RowNum"],
        categoryId: json["CategoryID"],
        categoryName: json["CategoryName"],
        categoryNameUrl: json["CategoryNameURL"],
        categoryDescription: json["CategoryDescription"],
        productId: json["ProductID"],
        productName: json["ProductName"],
        productNameUrl: json["ProductNameURL"],
        productTotalAttributes: json["ProductTotalAttributes"],
        attributeValue1Id: json["AttributeValue1ID"],
        attributeValue1Name: json["AttributeValue1Name"],
        attributeValue2Id: json["AttributeValue2ID"],
        attributeValue2Name: json["AttributeValue2Name"],
        productTranId: json["ProductTranID"],
        productImageId: json["ProductImageID"],
        productImageUrl: json["ProductImageURL"],
        coverImage: json["CoverImage"],
        productImageType: json["ProductImageType"],
        altText: json["AltText"],
        imageCaption: json["ImageCaption"],
        isAddedForQuotation: json["IsAddedForQuotation"],
      );
}
