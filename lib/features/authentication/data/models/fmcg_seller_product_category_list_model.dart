class FmcgSellerProductCategoryListModel {
  final int? categoryId;
  final String? name;
  final String? insertedDate;

  FmcgSellerProductCategoryListModel({
    this.categoryId,
    this.name,
    this.insertedDate,
  });

  factory FmcgSellerProductCategoryListModel.fromJson(
          Map<String, dynamic> json) =>
      FmcgSellerProductCategoryListModel(
        categoryId: json["CategoryID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );

  Map<String, dynamic> toJson() => {
        "CategoryID": categoryId,
        "Name": name,
        "InsertedDate": insertedDate,
      };
}
