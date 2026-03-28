import 'package:equatable/equatable.dart';

class FmcgBuyerDistributionCoverageList extends Equatable {
  final int? coverageId;
  final String? name;
  final String? insertedDate;

  const FmcgBuyerDistributionCoverageList({
    this.coverageId,
    this.name,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [coverageId, name, insertedDate];
}
