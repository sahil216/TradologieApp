class FmcgBuyerBrandPartnershipTypeListModel {
  final int? typeId;
  final String? name;
  final String? insertedDate;

  FmcgBuyerBrandPartnershipTypeListModel({
    this.typeId,
    this.name,
    this.insertedDate,
  });

  factory FmcgBuyerBrandPartnershipTypeListModel.fromJson(
          Map<String, dynamic> json) =>
      FmcgBuyerBrandPartnershipTypeListModel(
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
