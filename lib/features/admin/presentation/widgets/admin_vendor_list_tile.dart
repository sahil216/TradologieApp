import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/admin/domain/entities/admin_vendor.dart';

/// Shared list row for recent chats and vendor search results.
class AdminVendorListTile extends StatelessWidget {
  final AdminVendor vendor;
  final VoidCallback onTap;

  const AdminVendorListTile({
    super.key,
    required this.vendor,
    required this.onTap,
  });

  String _initial(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed[0].toUpperCase();
  }

  String _formatDate(String raw) {
    if (raw.trim().isEmpty) return '';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormat('dd MMM yyyy, hh:mm a').format(parsed.toLocal());
  }

  Widget _detailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade600),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: TextStyleConstants.regular(
                  context,
                  fontSize: 12,
                  color: Colors.grey.shade700,
                ),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (vendor.hasProfileImage) {
      try {
        final bytes = base64Decode(vendor.vendorImage);
        return CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          backgroundImage: MemoryImage(bytes),
        );
      } catch (_) {
        // Fall through to initials avatar.
      }
    }

    return CircleAvatar(
      radius: 28,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      child: Text(
        _initial(vendor.displayName),
        style: TextStyleConstants.semiBold(
          context,
          fontSize: 18,
          color: AppColors.primary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lastChat = _formatDate(vendor.lastChatDate);
    final registered = _formatDate(vendor.registrationDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatar(context),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              vendor.displayName,
                              style: TextStyleConstants.semiBold(
                                context,
                                fontSize: 15,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.chat_bubble_outline,
                            size: 18,
                            color: AppColors.primary.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                      if (vendor.vendorCode.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            vendor.vendorCode,
                            style: TextStyleConstants.medium(
                              context,
                              fontSize: 12,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      _detailRow(
                        context,
                        icon: Icons.badge_outlined,
                        label: 'Vendor ID',
                        value: vendor.vendorId > 0
                            ? vendor.vendorId.toString()
                            : '',
                      ),
                      _detailRow(
                        context,
                        icon: Icons.phone_outlined,
                        label: 'Mobile',
                        value: vendor.mobileNo,
                      ),
                      _detailRow(
                        context,
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: vendor.emailId,
                      ),
                      _detailRow(
                        context,
                        icon: Icons.public_outlined,
                        label: 'Country',
                        value: vendor.countryName,
                      ),
                      _detailRow(
                        context,
                        icon: Icons.schedule_outlined,
                        label: 'Last chat',
                        value: lastChat,
                      ),
                      _detailRow(
                        context,
                        icon: Icons.event_outlined,
                        label: 'Registered',
                        value: registered,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
