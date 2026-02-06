import 'package:flutter/material.dart';

import 'package:tradologie_app/core/utils/extensions.dart';

import '../utils/app_colors.dart';
import 'custom_text/text_style_constants.dart';

class CustomSelectWidget extends StatelessWidget {
  final double heightIcon;
  final String? icon;
  final String? hintText;
  final String? titleText;

  final Color? iconColor;

  final void Function()? onClick;
  final ValueNotifier valueSelected;

  const CustomSelectWidget({
    super.key,
    this.heightIcon = 7.55,
    this.icon,
    this.hintText,
    this.titleText,
    this.iconColor,
    this.onClick,
    required this.valueSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (titleText != null)
          Container(
            margin: EdgeInsetsDirectional.only(start: 16, bottom: 3),
            child: Text(
              titleText ?? "",
              style: TextStyleConstants.medium(
                context,
                color: AppColors.black,
                fontSize: 15,
              ),
            ),
          ),
        GestureDetector(
          onTap: onClick,
          child: Container(
            height: 55,
            width: context.width,
            padding: EdgeInsets.symmetric(horizontal: 22),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: AppColors.border,
              ),
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: valueSelected,
                    builder: (context, value, _) {
                      return Text(
                        value is String ? value : value?.name ?? hintText ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: value == null
                            ? TextStyleConstants.medium(
                                context,
                                height: 2.2,
                                color: AppColors.grayText,
                              )
                            : TextStyleConstants.medium(
                                context,
                                height: 2.2,
                                fontSize: 19,
                                color: AppColors.black,
                              ),
                      );
                    },
                  ),
                ),
                Icon(
                  Icons.arrow_downward,
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
