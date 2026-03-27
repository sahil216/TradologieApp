class FmcgSellerPartnershipTypeListModel {
  final int? typeId;
  final String? name;
  final String? insertedDate;

  FmcgSellerPartnershipTypeListModel({
    this.typeId,
    this.name,
    this.insertedDate,
  });

  factory FmcgSellerPartnershipTypeListModel.fromJson(
          Map<String, dynamic> json) =>
      FmcgSellerPartnershipTypeListModel(
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
