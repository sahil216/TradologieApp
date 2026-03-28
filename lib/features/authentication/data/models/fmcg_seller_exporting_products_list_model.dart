import 'package:tradologie_app/features/authentication/domain/entities/fmcg_seller_exporting_products_list.dart';

class FmcgSellerExportingProductsListModel
    extends FmcgSellerExportingProductsList {
  const FmcgSellerExportingProductsListModel({
    super.exportingId,
    super.name,
    super.insertedDate,
  });

  factory FmcgSellerExportingProductsListModel.fromJson(
          Map<String, dynamic> json) =>
      FmcgSellerExportingProductsListModel(
        exportingId: json["ExportingID"],
        name: json["Name"],
        insertedDate: json["InsertedDate"],
      );
}
