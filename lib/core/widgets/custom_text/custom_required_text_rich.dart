import 'package:flutter/material.dart';

class CustomRequiredTextRich extends StatelessWidget {
  final String text;
  final int? maxLines;
  final bool showRequired;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextDirection? textDirection;

  const CustomRequiredTextRich({
    super.key,
    required this.text,
    this.maxLines,
    this.showRequired = true,
    required this.style,
    this.textAlign,
    this.overflow,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: style,
          ),
          if (showRequired)
            TextSpan(
              text: " *",
              style: style.copyWith(
                fontSize: (style.fontSize ?? 0) - 3,
              ),
            ),
        ],
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: textDirection,
    );
  }
}
