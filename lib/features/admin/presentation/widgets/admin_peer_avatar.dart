import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

/// Avatar for chat header and incoming message bubbles.
class AdminPeerAvatar extends StatelessWidget {
  final double radius;
  final bool useTradologieBranding;
  final String? imageBase64;
  final String fallbackInitial;

  const AdminPeerAvatar({
    super.key,
    this.radius = 22,
    this.useTradologieBranding = false,
    this.imageBase64,
    this.fallbackInitial = 'T',
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    if (useTradologieBranding) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white,
        child: ClipOval(
          child: Image.asset(
            ImgAssets.appLogo,
            width: size,
            height: size,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    final raw = imageBase64?.trim() ?? '';
    if (raw.isNotEmpty) {
      try {
        final bytes = base64Decode(raw);
        return CircleAvatar(
          radius: radius,
          backgroundColor: AppColors.primary.withValues(alpha: 0.1),
          backgroundImage: MemoryImage(bytes),
        );
      } catch (_) {
        // Fall through to initials.
      }
    }

    final initial = _initial(fallbackInitial);
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
      child: Text(
        initial,
        style: TextStyleConstants.semiBold(
          context,
          fontSize: radius * 0.75,
          color: AppColors.primary,
        ),
      ),
    );
  }

  String _initial(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return '?';
    return trimmed[0].toUpperCase();
  }
}
