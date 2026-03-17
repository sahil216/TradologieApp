import 'package:equatable/equatable.dart';

class FmcgSellerTitle extends Equatable {
  final int? titleId;
  final String? titleName;

  const FmcgSellerTitle({
    this.titleId,
    this.titleName,
  });

  @override
  List<Object?> get props => [titleId, titleName];
}
