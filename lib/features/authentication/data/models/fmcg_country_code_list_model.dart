import 'package:tradologie_app/features/authentication/domain/entities/fmcg_country_code_list.dart';

class FmcgCountryCodeListModel extends FmcgCountryCodeList {
  const FmcgCountryCodeListModel({
    super.id,
    super.name,
    super.codeIso2,
    super.countryCode,
    super.countryText,
  });

  factory FmcgCountryCodeListModel.fromJson(Map<String, dynamic> json) =>
      FmcgCountryCodeListModel(
        id: json["Id"],
        name: json["Name"],
        codeIso2: json["codeISO2"],
        countryCode: json["CountryCode"],
        countryText: json["CountryText"],
      );
}
