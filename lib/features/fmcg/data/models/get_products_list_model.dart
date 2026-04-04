import 'package:tradologie_app/features/fmcg/domain/entities/get_products_list.dart';

class GetProductsListModel extends GetProductsList {
  const GetProductsListModel({
    super.categoryId,
    super.categoryName,
    super.productId,
    super.productName,
    super.productNameUrl,
    super.productImageId,
    super.productImageUrl,
    super.altText,
    super.imageCaption,
  });

  factory GetProductsListModel.fromJson(Map<String, dynamic> json) =>
      GetProductsListModel(
        categoryId: json["CategoryID"],
        categoryName: json["CategoryName"],
        productId: json["ProductID"],
        productName: json["ProductName"],
        productNameUrl: json["ProductNameURL"],
        productImageId: json["ProductImageID"],
        productImageUrl: json["ProductImageURL"],
        altText: json["AltText"],
        imageCaption: json["ImageCaption"],
      );
}
