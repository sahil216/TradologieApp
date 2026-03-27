class FmcgSellerBusinessTypeListModel {
  final int? typeId;
  final String? name;
  final String? insertedDate;

  FmcgSellerBusinessTypeListModel({
    this.typeId,
    this.name,
    this.insertedDate,
  });

  factory FmcgSellerBusinessTypeListModel.fromJson(Map<String, dynamic> json) =>
      FmcgSellerBusinessTypeListModel(
        typeId: json["TypeID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );

  Map<String, dynamic> toJson() => {
        "TypeID": typeId,
        "Name": name,
        "InsertedDate": insertedDate,
      };
}
