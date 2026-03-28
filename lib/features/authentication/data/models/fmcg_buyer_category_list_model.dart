import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_category_list.dart';

class FmcgBuyerCategoryListModel extends FmcgBuyerCategoryList {
  const FmcgBuyerCategoryListModel({
    super.categoryId,
    super.name,
    super.insertedDate,
  });

  factory FmcgBuyerCategoryListModel.fromJson(Map<String, dynamic> json) =>
      FmcgBuyerCategoryListModel(
        categoryId: json["CategoryID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );
}
