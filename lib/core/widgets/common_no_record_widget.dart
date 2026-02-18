import 'package:flutter/material.dart';
import 'package:tradologie_app/core/widgets/custom_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

class CommonNoRecordWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final String buttonText;
  const CommonNoRecordWidget(
      {super.key,
      required this.onTap,
      required this.text,
      required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CommonText(text,
              style: TextStyleConstants.semiBold(context, fontSize: 16)),
          SizedBox(height: 20),
          CommonButton(onPressed: onTap, text: buttonText),
        ],
      ),
    );
  }
}
