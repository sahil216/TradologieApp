import 'package:equatable/equatable.dart';

class AttributeList extends Equatable {
  final String? attributeValueId;
  final String? attributeValue;

  const AttributeList({
    this.attributeValueId,
    this.attributeValue,
  });

  @override
  List<Object?> get props => [attributeValueId, attributeValue];
}
