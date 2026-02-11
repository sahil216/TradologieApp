import 'package:equatable/equatable.dart';

class CurrencyList extends Equatable {
  final int? currencyId;
  final String? currencyName;

  const CurrencyList({
    this.currencyId,
    this.currencyName,
  });

  @override
  List<Object?> get props => [currencyId, currencyName];
}
