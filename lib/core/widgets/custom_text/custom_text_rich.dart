import 'package:flutter/material.dart';

class CustomTextRich extends StatelessWidget {
  final List<InlineSpan> children;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextDirection? textDirection;

  const CustomTextRich({
    super.key,
    required this.children,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: children,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      textDirection: textDirection,
    );
  }
}
