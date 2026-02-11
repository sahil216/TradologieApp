import 'package:equatable/equatable.dart';

class CustomerAddressList extends Equatable {
  final String? address;
  final String? addressValue;

  const CustomerAddressList({
    this.address,
    this.addressValue,
  });

  @override
  List<Object?> get props => [address, addressValue];
}
