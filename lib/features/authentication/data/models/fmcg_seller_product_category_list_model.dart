import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_product_category_list.dart';

class FmcgSellerProductCategoryListModel extends FmcgSellerProductCategoryList {
  const FmcgSellerProductCategoryListModel({
    super.categoryId,
    super.name,
    super.insertedDate,
  });

  factory FmcgSellerProductCategoryListModel.fromJson(
          Map<String, dynamic> json) =>
      FmcgSellerProductCategoryListModel(
        categoryId: json["CategoryID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );
}
