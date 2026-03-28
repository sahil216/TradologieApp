import 'package:equatable/equatable.dart';

class FmcgSellerExportingProductsList extends Equatable {
  final int? exportingId;
  final String? name;
  final String? insertedDate;

  const FmcgSellerExportingProductsList({
    this.exportingId,
    this.name,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [exportingId, name, insertedDate];
}
