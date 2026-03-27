import 'package:equatable/equatable.dart';

class FmcgSellerServiceLabelList extends Equatable {
  final int? labelId;
  final String? name;
  final String? insertedDate;

  const FmcgSellerServiceLabelList({
    this.labelId,
    this.name,
    this.insertedDate,
  });

  @override
  List<Object?> get props => [labelId, name, insertedDate];
}
