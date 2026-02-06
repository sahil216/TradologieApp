import 'package:equatable/equatable.dart';

class SelectModel extends Equatable {
  final String id;
  final String value;
  final String countryCode;

  const SelectModel(
      {required this.id, required this.value, this.countryCode = ""});

  @override
  List<Object?> get props => [id, value, countryCode];
}
