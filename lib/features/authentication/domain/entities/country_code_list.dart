import 'package:equatable/equatable.dart';

class CountryCodeList extends Equatable {
  final int? countryId;
  final String? countryName;
  final String? countryCode;
  final String? countryValue;

  const CountryCodeList({
    this.countryId,
    this.countryName,
    this.countryCode,
    this.countryValue,
  });

  @override
  List<Object?> get props => [
        countryId,
        countryName,
        countryCode,
        countryValue,
      ];
}
