import 'package:tradologie_app/features/add_negotiation/domian/enitities/currency_list.dart';

class CurrencyListModel extends CurrencyList {
  const CurrencyListModel({
    super.currencyId,
    super.currencyName,
  });

  factory CurrencyListModel.fromJson(Map<String, dynamic> json) =>
      CurrencyListModel(
        currencyId: json["CurrencyID"],
        currencyName: json["CurrencyName"],
      );
}
