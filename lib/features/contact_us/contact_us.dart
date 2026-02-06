import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_single_child_scroll_view.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $url';
    }
  }

  Widget sectionTitle(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        SizedBox(width: 8),
        CommonText(
          title,
          style: TextStyleConstants.bold(
            context,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget infoCommonText(BuildContext context, String text,
      {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: CommonText(
          text,
          style: TextStyleConstants.medium(
            context,
            fontSize: 16,
            color: onTap != null ? AppColors.primary : AppColors.defaultText,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: Constants.appBar(context,
          title: "Contact Us",
          backgroundColor: Colors.white,
          centerTitle: true),
      body: SafeArea(
        child: Align(
          alignment: AlignmentGeometry.topCenter,
          child: CommonSingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🌍 VISIT US
                  sectionTitle(context, Icons.location_on, "Visit Us"),
                  const SizedBox(height: 8),
                  CommonText(
                    "Global Headquarter",
                    style: TextStyleConstants.semiBold(context),
                  ),
                  infoCommonText(context,
                      "Green Boulevard, Plot No. B-9/A, 6th Floor,\n Tower B, Sector 62, Noida, Uttar Pradesh - 201309 (India)"),
                  const SizedBox(height: 10),
                  CommonText(
                    "Regional Offices for GCC & MENA",
                    style: TextStyleConstants.semiBold(context),
                  ),
                  infoCommonText(context,
                      "Unit No: 05-PF-CWC15, Detached Retail 05, Plot No: Level No 1,\nJumeirah Lakes Towers, Dubai, United Arab Emirates"),

                  const SizedBox(height: 24),

                  /// 📞 CALL US
                  sectionTitle(context, Icons.phone, "Call Us"),
                  const SizedBox(height: 8),
                  infoCommonText(context, "+91-120-4148742",
                      onTap: () => _launchUrl("tel:+911204148742")),
                  infoCommonText(context, "+91-120-4148743",
                      onTap: () => _launchUrl("tel:+911204148743")),
                  infoCommonText(context, "+91-8595957412",
                      onTap: () => _launchUrl("tel:+918595957412")),

                  const SizedBox(height: 24),

                  InkWell(
                    onTap: () {
                      _launchUrl(
                          "https://api.whatsapp.com/send?phone=+917303062414&text=Hi%2C%20I%27m%20looking%20to%20explore%20opportunities%20in%20the%20agro-commodities%20ecosystem.%20Could%20you%20share%20more%20details%3F");
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color(0xFF25D366), width: 5),
                        // color: const Color(0xFF25D366), // WhatsApp green
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(ImgAssets.whatsappIcon),
                          SizedBox(width: 8),
                          Text(
                            'Whatsapp',
                            style: TextStyleConstants.semiBold(
                              context,
                              color: AppColors.defaultText,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  /// ✉️ EMAIL US
                  sectionTitle(context, Icons.email, "Email Us"),
                  const SizedBox(height: 8),
                  infoCommonText(context, "info@tradologie.com",
                      onTap: () => _launchUrl("mailto:info@tradologie.com")),
                  // infoCommonText(context, "support@tradologie.com",
                  //     onTap: () => _launchUrl("mailto:support@tradologie.com")),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
