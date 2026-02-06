import 'package:tradologie_app/features/negotiation/data/models/buyer_negotiation_detail_model.dart';

import '../../domain/entities/buyer_negotiation.dart';
import '../../domain/entities/buyer_negotitation_detail.dart';

class BuyerNegotiationModel extends BuyerNegotiation {
  const BuyerNegotiationModel({
    super.detail,
    super.success,
    super.message,
    super.totalRecords,
    super.totalPages,
  });

  factory BuyerNegotiationModel.fromJson(Map<String, dynamic> json) =>
      BuyerNegotiationModel(
        detail: json["detail"] == null
            ? []
            : List<BuyerNegotiationDetail>.from(json["detail"]!
                .map((x) => BuyerNegotiationDetailModel.fromJson(x))),
        success: json["success"],
        message: json["message"],
        totalRecords: json["totalRecords"],
        totalPages: json["totalPages"],
      );
}
