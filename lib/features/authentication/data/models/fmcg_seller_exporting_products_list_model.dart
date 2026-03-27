class FmcgSellerExportingProductsListModel {
  final int? exportingId;
  final String? name;
  final String? insertedDate;

  FmcgSellerExportingProductsListModel({
    this.exportingId,
    this.name,
    this.insertedDate,
  });

  factory FmcgSellerExportingProductsListModel.fromJson(
          Map<String, dynamic> json) =>
      FmcgSellerExportingProductsListModel(
        exportingId: json["ExportingID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );

  Map<String, dynamic> toJson() => {
        "ExportingID": exportingId,
        "Name": name,
        "InsertedDate": insertedDate,
      };
}
