import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/presentation/view_model/tab_view_model.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final List<TabViewModel> tabs;
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: bottomInset), // 👈 extend background
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: Offset(0, -2),
            color: Colors.black12,
          ),
        ],
      ),

      /// 👇 actual bar content height
      child: SizedBox(
        height: 80,
        child: Row(
          children: tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final isActive = index == currentIndex;

            final iconColor =
                isActive ? Colors.black : Colors.black.withValues(alpha: .65);

            final textColor =
                isActive ? Colors.black : Colors.black.withValues(alpha: .55);

            return Expanded(
              child: _UltraHapticTabItem(
                isActive: isActive,
                icon: (item.icon as Icon).icon!,
                label: item.name,
                onTap: () => onTap(index),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _UltraHapticTabItem extends StatefulWidget {
  final bool isActive;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _UltraHapticTabItem({
    required this.isActive,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_UltraHapticTabItem> createState() => _UltraHapticTabItemState();
}

class _UltraHapticTabItemState extends State<_UltraHapticTabItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  void _handleTapDown(_) {
    _pressController.forward();
  }

  void _handleTapUp(_) {
    _pressController.reverse();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final iconColor =
        widget.isActive ? Colors.black : Colors.black.withValues(alpha: .65);

    final textColor =
        widget.isActive ? Colors.black : Colors.black.withValues(alpha: .55);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _handleTapDown,
      onTapUp: (d) {
        _handleTapUp(d);

        /// 🍎 Ultra haptic feedback
        HapticFeedback.selectionClick();

        widget.onTap();
      },
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          final pressValue = _pressController.value;

          /// 🔥 press scale + lift effect
          final scale = 1 - (pressValue * 0.06);
          final lift = widget.isActive ? 1.08 : 1.0;

          return Transform.translate(
            offset: Offset(0, -pressValue * 2),
            child: Transform.scale(
              scale: scale * lift,
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, size: 26, color: iconColor),
                    const SizedBox(height: 4),
                    Text(
                      widget.label,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                      style: TextStyleConstants.medium(
                        context,
                        fontSize: 11,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
