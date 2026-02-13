import 'package:flutter/material.dart';

class AnimatedSelectableCircle extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final double size;
  final Color activeColor;
  final Color borderColor;

  const AnimatedSelectableCircle({
    super.key,
    required this.selected,
    required this.onTap,
    this.size = 24,
    this.activeColor = Colors.blue,
    this.borderColor = const Color(0xffD0D5DD),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected ? activeColor : Colors.transparent,
            border: Border.all(
              color: selected ? activeColor : borderColor,
              width: 2,
            ),
          ),

          /// CHECK ICON ANIMATION
          child: Center(
            child: AnimatedScale(
              scale: selected ? 1 : 0,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: const Icon(
                Icons.check,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
