class FmcgBuyerCategoryListModel {
  final int? categoryId;
  final String? name;
  final String? insertedDate;

  FmcgBuyerCategoryListModel({
    this.categoryId,
    this.name,
    this.insertedDate,
  });

  factory FmcgBuyerCategoryListModel.fromJson(Map<String, dynamic> json) =>
      FmcgBuyerCategoryListModel(
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
