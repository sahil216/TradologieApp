import 'package:flutter/material.dart';

import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/common_strings.dart';
import 'package:tradologie_app/core/widgets/common_social_media_button.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

class ContinueWhatsappWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  const ContinueWhatsappWidget({
    super.key,
    required this.onTap,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: CommonText(
            CommonStrings.orContinueWith,
            style: TextStyleConstants.regular(
              context,
              fontSize: 16,
              color: AppColors.defaultText,
            ),
          ),
        ),
        SizedBox(height: 30),
        Center(
            child: CommonSocialMediaButton(
                onTap: onTap, iconPath: ImgAssets.whatsappIcon)),
      ],
    );
  }
}
