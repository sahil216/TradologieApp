import 'package:flutter/material.dart';

/// Small green pulsing dot — online / active indicator.
class BlinkingOnlineDot extends StatefulWidget {
  final double size;
  final Color color;

  const BlinkingOnlineDot({
    super.key,
    this.size = 10,
    this.color = const Color(0xFF22C55E),
  });

  @override
  State<BlinkingOnlineDot> createState() => _BlinkingOnlineDotState();
}

class _BlinkingOnlineDotState extends State<BlinkingOnlineDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  late final Animation<double> _opacity = Tween<double>(
    begin: 0.35,
    end: 1.0,
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.45),
              blurRadius: widget.size * 0.6,
              spreadRadius: widget.size * 0.15,
            ),
          ],
        ),
      ),
    );
  }
}
