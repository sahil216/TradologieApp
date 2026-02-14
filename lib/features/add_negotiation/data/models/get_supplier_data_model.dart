import 'package:tradologie_app/features/add_negotiation/data/models/get_supplier_list_model.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_data.dart';
import 'package:tradologie_app/features/add_negotiation/domian/enitities/supplier_list.dart';

class GetSupplierDataModel extends GetSupplierData {
  const GetSupplierDataModel({
    super.detail,
    super.success,
    super.message,
    super.totalRecords,
    super.totalPages,
  });

  factory GetSupplierDataModel.fromJson(Map<String, dynamic> json) =>
      GetSupplierDataModel(
        detail: json["detail"] == null
            ? []
            : List<SupplierList>.from(
                json["detail"]!.map((x) => SupplierListModel.fromJson(x))),
        success: json["success"],
        message: json["message"],
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
      );
}
