import 'dart:ui';

import 'package:flutter/material.dart';

class CommonFMCGFloatingNavBar extends StatelessWidget {
  final int index;
  final Function(int) onTap;

  const CommonFMCGFloatingNavBar({
    super.key,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .75),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withValues(alpha: .08),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _item(0, Icons.dashboard_outlined, "Dashboard"),
                _item(1, Icons.chat_outlined, "Chats"),
                _item(2, Icons.account_circle_outlined, "My Account"),
                _item(3, Icons.payment_outlined, "Membership"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int i, IconData icon, String label) {
    final bool active = i == index;

    return GestureDetector(
      onTap: () => onTap(i),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
          horizontal: active ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: active ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: active ? Colors.white : Colors.black54,
            ),
            if (active) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
