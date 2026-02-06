import 'package:tradologie_app/features/negotiation/data/models/negotiation_result_model.dart';
import 'package:tradologie_app/features/negotiation/domain/entities/negotiation_result.dart';

import '../../domain/entities/negotiation.dart';

class NegotiationModel extends Negotiation {
  const NegotiationModel({
    super.detail,
    super.success,
    super.message,
    super.totalRecords,
    super.totalPages,
  });

  factory NegotiationModel.fromJson(Map<String, dynamic> json) =>
      NegotiationModel(
        detail: json["detail"] == null
            ? []
            : List<NegotiationResult>.from(
                json["detail"]!.map((x) => NegotiationResultModel.fromJson(x))),
        success: json["success"],
        message: json["message"],
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
      );
}
