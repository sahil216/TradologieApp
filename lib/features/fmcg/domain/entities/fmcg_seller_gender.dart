import 'package:equatable/equatable.dart';

class FmcgSellerGender extends Equatable {
  final int? genderId;
  final String? genderName;

  const FmcgSellerGender({
    this.genderId,
    this.genderName,
  });

  @override
  List<Object?> get props => [genderId, genderName];
}
