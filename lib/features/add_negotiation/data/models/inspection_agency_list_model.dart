import 'package:tradologie_app/features/add_negotiation/domian/enitities/inspection_agency_list.dart';

class InspectionAgencyListModel extends InspectionAgencyList {
  const InspectionAgencyListModel({
    super.inspectionAgencyId,
    super.inspectionCompanyName,
  });

  factory InspectionAgencyListModel.fromJson(Map<String, dynamic> json) =>
      InspectionAgencyListModel(
        inspectionAgencyId: json["InspectionAgencyID"],
        inspectionCompanyName: json["InspectionCompanyName"],
      );
}
