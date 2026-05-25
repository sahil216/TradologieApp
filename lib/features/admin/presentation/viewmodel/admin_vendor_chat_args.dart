import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_connect_chat_config.dart';

class AdminVendorChatArgs {
  final String categoryTitle;
  final String signalRType1;
  final String signalRType2;

  const AdminVendorChatArgs({
    required this.categoryTitle,
    this.signalRType1 = AdminChatConfig.type1,
    this.signalRType2 = AdminChatConfig.type2,
  });
}
