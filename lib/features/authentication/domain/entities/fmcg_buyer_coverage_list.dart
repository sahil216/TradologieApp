import 'package:equatable/equatable.dart';

class FmcgBuyerCoverageList extends Equatable {
  final int? coverageId;
  final String? name;
  final String? insertedDate;

  const FmcgBuyerCoverageList({
    this.coverageId,
    this.name,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [coverageId, name, insertedDate];
}
