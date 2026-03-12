import 'package:equatable/equatable.dart';

class FmcgCountryCodeList extends Equatable {
  final int? id;
  final String? name;
  final String? codeIso2;
  final String? countryCode;
  final String? countryText;

  const FmcgCountryCodeList({
    this.id,
    this.name,
    this.codeIso2,
    this.countryCode,
    this.countryText,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        codeIso2,
        countryCode,
        countryText,
      ];
}
