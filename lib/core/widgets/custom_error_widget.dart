import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

import 'custom_icon_button.dart';
import 'custom_text/text_style_constants.dart';

class CustomErrorWidget extends StatelessWidget {
  final String? errorText;
  final VoidCallback? onPress;
  const CustomErrorWidget({super.key, this.errorText, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.error_outline,
            color: AppColors.red,
            size: 200,
          ),
          Text(
            errorText ?? ('something_went_wrong'),
            textAlign: TextAlign.center,
            style: TextStyleConstants.semiBold(
              context,
              color: AppColors.black,
              fontSize: 14,
            ),
          ),
          errorText == null
              ? Text(
                  ('try_again'),
                  textAlign: TextAlign.center,
                  style: TextStyleConstants.medium(
                    context,
                    color: AppColors.black,
                    fontSize: 12,
                  ),
                )
              : Container(),
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
            widget: Icon(
              Icons.rotate_right,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
