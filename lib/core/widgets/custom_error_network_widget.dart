import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

import 'custom_icon_button.dart';
import 'custom_text/text_style_constants.dart';

class CustomErrorNetworkWidget extends StatelessWidget {
  final VoidCallback? onPress;
  const CustomErrorNetworkWidget({super.key, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            color: AppColors.red,
            size: 170,
          ),
          Text(
            "Please check your Internet connection and try again",
            textAlign: TextAlign.center,
            style: TextStyleConstants.regular(
              context,
              color: AppColors.black,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 70,
          ),
          CustomIconButton(
            onPressed: () {
              if (onPress != null) {
                onPress!();
              }
            },
            backgroundColor: AppColors.white,
            shape: BoxShape.circle,
            iconHeight: 50,
            iconColor: AppColors.red,
            widget: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
