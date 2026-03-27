class FmcgSellerServiceLabelListModel {
  final int? labelId;
  final String? name;
  final String? insertedDate;

  FmcgSellerServiceLabelListModel({
    this.labelId,
    this.name,
    this.insertedDate,
  });

  factory FmcgSellerServiceLabelListModel.fromJson(Map<String, dynamic> json) =>
      FmcgSellerServiceLabelListModel(
        labelId: json["LabelID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );

  Map<String, dynamic> toJson() => {
        "LabelID": labelId,
        "Name": name,
        "InsertedDate": insertedDate,
      };
}
