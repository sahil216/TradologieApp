import 'package:flutter/material.dart';

import '../utils/assets_manager.dart';
import '../utils/common_strings.dart';
import '../utils/constants.dart';
import '../utils/responsive.dart';
import 'common_social_media_button.dart';
import 'custom_text/common_text_widget.dart';
import 'custom_text/text_style_constants.dart';

class CommonSocialIcons extends StatelessWidget {
  const CommonSocialIcons({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: r.value(mobile: 20, tablet: 32),
          vertical: r.value(mobile: 12, tablet: 16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonText(
              "Follow us on",
              textAlign: TextAlign.center,
              style: TextStyleConstants.regular(
                context,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: r.isTablet ? 420 : double.infinity,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CommonSocialMediaButton(
                        onTap: () =>
                            Constants.launch(CommonStrings.facebookUrl),
                        iconPath: ImgAssets.facebook,
                      ),
                    ),
                    SizedBox(width: r.value(mobile: 8, tablet: 16)),
                    Expanded(
                      child: CommonSocialMediaButton(
                        onTap: () =>
                            Constants.launch(CommonStrings.linkedinUrl),
                        iconPath: ImgAssets.linkedin,
                      ),
                    ),
                    SizedBox(width: r.value(mobile: 8, tablet: 16)),
                    Expanded(
                      child: CommonSocialMediaButton(
                        onTap: () => Constants.launch(CommonStrings.xUrl),
                        iconPath: ImgAssets.x,
                      ),
                    ),
                    SizedBox(width: r.value(mobile: 8, tablet: 16)),
                    Expanded(
                      child: CommonSocialMediaButton(
                        onTap: () => Constants.launch(CommonStrings.youtubeUrl),
                        iconPath: ImgAssets.youtube,
                      ),
                    ),
                    SizedBox(width: r.value(mobile: 8, tablet: 16)),
                    Expanded(
                      child: CommonSocialMediaButton(
                        onTap: () =>
                            Constants.launch(CommonStrings.instagramUrl),
                        iconPath: ImgAssets.instagram,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
