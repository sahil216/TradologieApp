import 'package:tradologie_app/features/add_negotiation/domian/enitities/customer_address_list.dart';

class CustomerAddressListModel extends CustomerAddressList {
  const CustomerAddressListModel({
    super.address,
    super.addressValue,
  });

  factory CustomerAddressListModel.fromJson(Map<String, dynamic> json) =>
      CustomerAddressListModel(
        address: json["Address"],
        addressValue: json["AddressValue"],
      );
}
