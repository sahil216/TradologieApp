import 'package:tradologie_app/features/admin/domain/entities/admin_vendor.dart';

/// Vendor Connect (More Options) — fixed SignalR / history targets.
class AdminConnectChatConfig {
  AdminConnectChatConfig._();

  static const String type1 = 'AgroAdminSellerChat';
  static const String type2 = 'Vendor';
  static const String toUserId = '2';
  static const int historyToUserId = 2;
  static const String chatTitle = 'Connect';

  static const AdminVendor displayVendor = AdminVendor(
    vendorId: 2,
    vendorCode: '',
    vendorName: chatTitle,
    mobileNo: '',
    countryName: '',
    emailId: '',
    registrationDate: '',
  );
}

/// Admin vendor list → conversation uses selected vendor id as toUserId.
class AdminChatConfig {
  AdminChatConfig._();

  static const String type1 = 'AgroAdminSellerChat';
  static const String type2 = 'Admin';
}
