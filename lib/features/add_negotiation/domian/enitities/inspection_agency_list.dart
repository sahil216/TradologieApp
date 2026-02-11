import 'package:equatable/equatable.dart';

class InspectionAgencyList extends Equatable {
  final int? inspectionAgencyId;
  final String? inspectionCompanyName;

  const InspectionAgencyList({
    this.inspectionAgencyId,
    this.inspectionCompanyName,
  });

  @override
  List<Object?> get props => [inspectionAgencyId, inspectionCompanyName];
}
