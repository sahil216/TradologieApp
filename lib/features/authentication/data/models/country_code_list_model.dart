import 'package:tradologie_app/features/authentication/domain/entities/country_code_list.dart';

class CountryCodeListModel extends CountryCodeList {
  const CountryCodeListModel({
    super.countryId,
    super.countryName,
    super.countryCode,
    super.countryValue,
  });

  factory CountryCodeListModel.fromJson(Map<String, dynamic> json) =>
      CountryCodeListModel(
        countryId: json["CountryID"],
        countryName: json["CountryName"],
        countryCode: json["CountryCode"],
        countryValue: json["CountryValue"],
      );
}
