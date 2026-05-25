import 'package:tradologie_app/features/admin/domain/entities/admin_vendor.dart';

class AdminVendorConversationArgs {
  final AdminVendor vendor;
  final String chatType1;
  final String chatType2;
  final bool isConnectChat;

  const AdminVendorConversationArgs({
    required this.vendor,
    required this.chatType1,
    required this.chatType2,
    this.isConnectChat = false,
  });
}
