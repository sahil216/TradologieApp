import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/core/widgets/seller_drawer_menu_button.dart';
import 'package:tradologie_app/features/admin/presentation/widgets/admin_peer_avatar.dart';

/// App bar for admin / vendor connect chat with role-based peer display.
class AdminChatHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool useTradologieBranding;
  final String? peerImageBase64;
  final String fallbackInitial;
  final VoidCallback? onBack;

  const AdminChatHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.useTradologieBranding = false,
    this.peerImageBase64,
    this.fallbackInitial = 'T',
    this.onBack,
  });

  @override
  Size get preferredSize {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;
    return Size.fromHeight(hasSubtitle ? 72 : kToolbarHeight);
  }

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null && subtitle!.trim().isNotEmpty;

    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      shadowColor: Colors.black12,
      leading: Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: onBack ?? () => Navigator.maybePop(context),
            )
          : const SellerDrawerMenuButton(iconSize: 22),
      titleSpacing: 0,
      title: Row(
        children: [
          AdminPeerAvatar(
            radius: 22,
            useTradologieBranding: useTradologieBranding,
            imageBase64: peerImageBase64,
            fallbackInitial: fallbackInitial,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyleConstants.semiBold(
                    context,
                    fontSize: 17,
                    color: Colors.black87,
                  ),
                ),
                if (hasSubtitle)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyleConstants.regular(
                      context,
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: AppColors.primary.withValues(alpha: 0.08),
        ),
      ),
    );
  }
}
