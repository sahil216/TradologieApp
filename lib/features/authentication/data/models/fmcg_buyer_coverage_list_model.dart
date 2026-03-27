class FmcgBuyerCoverageListModel {
  final int? coverageId;
  final String? name;
  final String? insertedDate;

  FmcgBuyerCoverageListModel({
    this.coverageId,
    this.name,
    this.insertedDate,
  });

  factory FmcgBuyerCoverageListModel.fromJson(Map<String, dynamic> json) =>
      FmcgBuyerCoverageListModel(
        coverageId: json["CoverageID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );

  Map<String, dynamic> toJson() => {
        "CoverageID": coverageId,
        "Name": name,
        "InsertedDate": insertedDate,
      };
}
