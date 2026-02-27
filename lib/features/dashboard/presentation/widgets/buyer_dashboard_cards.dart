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
    return LayoutBuilder(
      builder: (context, constraints) {
        final double w = constraints.maxWidth;

        // You can tweak these breakpoints anytime
        final bool compact = w < 140; // 3 cards on mobile
        final bool medium = w >= 140 && w < 190;

        final double iconBoxSize = compact ? 30 : (medium ? 46 : 54);
        final double iconSize = compact ? 16 : (medium ? 20 : 24);

        final double titleSize = compact ? 13 : (medium ? 15 : 18);
        final double subtitleSize = compact ? 10 : (medium ? 12 : 13);

        final double gapLarge = compact ? 8 : 14;
        final double gapSmall = compact ? 4 : 6;
        final double bottomGap = compact ? 6 : 12;
        final double scale = _pressed ? .96 : (_hover ? 1.02 : 1);

        Widget card = AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          transform: Matrix4.identity()
            ..scaleByDouble(scale, scale, scale, scale),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _hover ? .25 : .12),
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
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    padding: EdgeInsets.all(compact ? 12 : 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: .40),
                          Colors.white.withValues(alpha: .15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: widget.color.withValues(alpha: .25),
                        width: 1.2,
                      ),
                    ),

                    ////////////////////////////////////////////////////
                    /// ⭐ ADAPTIVE CONTENT
                    ////////////////////////////////////////////////////
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: iconBoxSize,
                          width: iconBoxSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                widget.color,
                                widget.color.withValues(alpha: .75),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: widget.color.withValues(alpha: .45),
                                blurRadius: 22,
                              )
                            ],
                          ),
                          child: Icon(
                            widget.icon,
                            color: Colors.white,
                            size: iconSize,
                          ),
                        ),
                        SizedBox(height: gapLarge),
                        Text(
                          widget.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: titleSize,
                            height: 1.2,
                            color: widget.color,
                          ),
                        ),
                        SizedBox(height: gapSmall),
                        Text(
                          widget.subtitle,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: subtitleSize,
                            height: 1.2,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: bottomGap),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(Icons.arrow_forward_ios,
                              size: compact ? 14 : 16, color: widget.color),
                        ),
                      ],
                    ),
                  ),
                ),

                ////////////////////////////////////////////////////////
                /// ✨ LIQUID HOVER SHINE
                ////////////////////////////////////////////////////////
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _hover ? .18 : 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.color.withValues(alpha: .5),
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

        if (widget.heroTag != null) {
          card = Hero(tag: widget.heroTag!, child: card);
        }

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
      },
    );
  }
}
