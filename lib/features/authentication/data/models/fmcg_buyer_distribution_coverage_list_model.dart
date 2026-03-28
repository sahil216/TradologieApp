import 'package:tradologie_app/features/authentication/domain/entities/fmcg_buyer_distribution_coverage_list.dart';

class FmcgBuyerDistributionCoverageListModel
    extends FmcgBuyerDistributionCoverageList {
  const FmcgBuyerDistributionCoverageListModel({
    super.coverageId,
    super.name,
    super.insertedDate,
  });

  factory FmcgBuyerDistributionCoverageListModel.fromJson(
          Map<String, dynamic> json) =>
      FmcgBuyerDistributionCoverageListModel(
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
