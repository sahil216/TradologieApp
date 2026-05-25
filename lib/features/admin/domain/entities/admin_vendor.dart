import 'package:equatable/equatable.dart';

class AdminVendor extends Equatable {
  final int vendorId;
  final String vendorCode;
  final String vendorName;
  final String mobileNo;
  final String countryName;
  final String emailId;
  final String registrationDate;
  final String vendorImage;
  final String lastChatDate;

  const AdminVendor({
    required this.vendorId,
    required this.vendorCode,
    required this.vendorName,
    required this.mobileNo,
    required this.countryName,
    required this.emailId,
    required this.registrationDate,
    this.vendorImage = '',
    this.lastChatDate = '',
  });

  /// Minimal vendor from FCM push (`fromid` + `name`).
  factory AdminVendor.fromPushNotification({
    required String vendorId,
    required String vendorName,
  }) {
    final id = int.tryParse(vendorId.trim()) ?? 0;
    final name = vendorName.trim();
    return AdminVendor(
      vendorId: id,
      vendorCode: '',
      vendorName: name.isNotEmpty ? name : 'Vendor',
      mobileNo: '',
      countryName: '',
      emailId: '',
      registrationDate: '',
    );
  }

  String get displayName =>
      vendorName.trim().isNotEmpty ? vendorName.trim() : vendorCode;

  bool get hasProfileImage => vendorImage.trim().isNotEmpty;

  @override
  List<Object?> get props => [
        vendorId,
        vendorCode,
        vendorName,
        mobileNo,
        countryName,
        emailId,
        registrationDate,
        vendorImage,
        lastChatDate,
      ];
}
