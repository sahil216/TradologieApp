import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/admin/domain/entities/admin_vendor.dart';
import 'package:tradologie_app/features/admin/presentation/cubit/admin_chat_cubit.dart';
import 'package:tradologie_app/features/admin/presentation/viewmodel/admin_connect_chat_config.dart';
import 'package:tradologie_app/features/admin/presentation/widgets/admin_chat_header.dart';
import 'package:tradologie_app/features/admin/presentation/widgets/admin_chat_view.dart';
import 'package:tradologie_app/injection_container.dart';

class AdminVendorConversationScreen extends StatefulWidget {
  final AdminVendor vendor;
  final String chatType1;
  final String chatType2;

  /// More Options → Connect: static SendMessage (toUserId=1, fixed Type1/Type2).
  final bool isConnectChat;

  const AdminVendorConversationScreen({
    super.key,
    required this.vendor,
    this.chatType1 = 'AgroAdminSellerChat',
    this.chatType2 = 'Vendor',
    this.isConnectChat = false,
  });

  @override
  State<AdminVendorConversationScreen> createState() =>
      _AdminVendorConversationScreenState();
}

class _AdminVendorConversationScreenState
    extends State<AdminVendorConversationScreen> {
  final _secureStorage = SecureStorageService();
  String _fromUserId = '';
  String _apiCode = '';

  bool get _isVendorSide =>
      !Constants.isFmcg && !Constants.isBuyer && !Constants.isAdmin;

  bool get _isAdmin => Constants.isAdmin;

  @override
  void initState() {
    super.initState();
    _loadSession();
  }

  Future<void> _loadSession() async {
    final loginId = await _secureStorage.read(AppStrings.loginId) ?? '';
    final userId = await _secureStorage.read(AppStrings.userId) ?? '';
    final vendorId = await _secureStorage.read(AppStrings.vendorId) ?? '';
    final token =
        await _secureStorage.read(AppStrings.apiVerificationCode) ??
            Constants.token;
    if (!mounted) return;
    setState(() {
      if (_isVendorSide) {
        _fromUserId = vendorId.isNotEmpty ? vendorId : loginId;
      } else if (_isAdmin) {
        _fromUserId = loginId.isNotEmpty ? loginId : userId;
      } else {
        _fromUserId = userId.isNotEmpty ? userId : loginId;
      }
      _apiCode = token;
    });
  }

  PreferredSizeWidget _buildAppBar() {
    final vendor = widget.vendor;

    if (_isVendorSide) {
      return const AdminChatHeader(
        title: 'Tradologie',
        useTradologieBranding: true,
      );
    }

    if (_isAdmin) {
      final subtitle = vendor.mobileNo.isNotEmpty
          ? vendor.mobileNo
          : (vendor.emailId.isNotEmpty ? vendor.emailId : null);

      return AdminChatHeader(
        title: vendor.displayName,
        subtitle: subtitle,
        peerImageBase64:
            vendor.hasProfileImage ? vendor.vendorImage : null,
        fallbackInitial: vendor.displayName,
      );
    }

    return AdminChatHeader(
      title: vendor.displayName,
      subtitle: vendor.mobileNo.isNotEmpty
          ? vendor.mobileNo
          : (vendor.emailId.isNotEmpty ? vendor.emailId : null),
      fallbackInitial: vendor.displayName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final vendor = widget.vendor;
    final useTradologieBranding = _isVendorSide;
    final displayName =
        useTradologieBranding ? 'Tradologie' : vendor.displayName;

    return BlocProvider(
      create: (_) => sl<AdminChatCubit>(),
      child: AdaptiveScaffold(
        appBar: _buildAppBar(),
        body: _fromUserId.isEmpty || _apiCode.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : AdminChatView(
                fromUserId: _fromUserId,
                toUserId: widget.isConnectChat
                    ? AdminConnectChatConfig.toUserId
                    : vendor.vendorId.toString(),
                apiCode: _apiCode,
                type1: widget.chatType1,
                type2: widget.chatType2,
                recipientName: displayName,
                isConnectChat: widget.isConnectChat,
                useTradologieBranding: useTradologieBranding,
                peerImageBase64: _isAdmin && vendor.hasProfileImage
                    ? vendor.vendorImage
                    : null,
              ),
      ),
    );
  }
}
