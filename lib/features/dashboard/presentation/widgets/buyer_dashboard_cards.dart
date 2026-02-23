import 'dart:ui';
import 'package:flutter/material.dart';

class BuyerDashboardCard extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final String? heroTag;

  const BuyerDashboardCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.heroTag,
  });

  @override
  State<BuyerDashboardCard> createState() => _BuyerDashboardCardState();
}

class _BuyerDashboardCardState extends State<BuyerDashboardCard> {
  bool _pressed = false;
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////////////////////////////////
    /// 🌊 DEPTH + LIQUID MOTION
    ////////////////////////////////////////////////////////////////
    final double scale = _pressed ? .96 : (_hover ? 1.02 : 1);

    Widget card = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
      transform: Matrix4.identity()..scale(scale),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        ////////////////////////////////////////////////////////////
        /// 🔥 EDGE GLOW LIGHTING
        ////////////////////////////////////////////////////////////
        boxShadow: [
          BoxShadow(
            color: widget.color.withOpacity(_hover ? .25 : .12),
            blurRadius: _hover ? 35 : 22,
            spreadRadius: _hover ? 1 : 0,
            offset: const Offset(0, 12),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            ////////////////////////////////////////////////////////
            /// GLASS BACKGROUND
            ////////////////////////////////////////////////////////
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(.40),
                      Colors.white.withOpacity(.15),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: widget.color.withOpacity(.25),
                    width: 1.2,
                  ),
                ),

                ////////////////////////////////////////////////////
                /// ⭐ INTRINSIC SAFE LAYOUT (NO OVERFLOW EVER)
                ////////////////////////////////////////////////////
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //////////////////////////////////////////////////
                    /// ICON WITH GLOW
                    //////////////////////////////////////////////////
                    Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            widget.color,
                            widget.color.withOpacity(.75),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.color.withOpacity(.45),
                            blurRadius: 22,
                          )
                        ],
                      ),
                      child: Icon(widget.icon, color: Colors.white),
                    ),

                    const SizedBox(height: 14),

                    //////////////////////////////////////////////////
                    /// TITLE
                    //////////////////////////////////////////////////
                    Text(
                      widget.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: widget.color,
                      ),
                    ),

                    const SizedBox(height: 6),

                    //////////////////////////////////////////////////
                    /// SUBTITLE
                    //////////////////////////////////////////////////
                    Text(
                      widget.subtitle,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 12),

                    //////////////////////////////////////////////////
                    /// ARROW
                    //////////////////////////////////////////////////
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Icon(Icons.arrow_forward_ios,
                          size: 16, color: widget.color),
                    ),
                  ],
                ),
              ),
            ),

            ////////////////////////////////////////////////////////
            /// ✨ LIQUID HOVER SHINE (ULTRA EFFECT)
            ////////////////////////////////////////////////////////
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _hover ? .18 : 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.color.withOpacity(.5),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    ////////////////////////////////////////////////////////////////
    /// HERO SUPPORT
    ////////////////////////////////////////////////////////////////
    if (widget.heroTag != null) {
      card = Hero(tag: widget.heroTag!, child: card);
    }

    ////////////////////////////////////////////////////////////////
    /// MATERIAL RIPPLE + MAGNETIC PRESS
    ////////////////////////////////////////////////////////////////
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: widget.onTap,
          onHighlightChanged: (v) => setState(() => _pressed = v),
          child: card,
        ),
      ),
    );
  }
}
