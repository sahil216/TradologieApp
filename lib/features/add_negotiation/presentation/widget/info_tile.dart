import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_Colors.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

class InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(label,
              style: TextStyleConstants.semiBold(context,
                  fontSize: 14, color: AppColors.defaultText)),
          const SizedBox(height: 4),
          CommonText(value,
              style: TextStyleConstants.medium(context,
                  fontSize: 16, color: AppColors.defaultText)),
        ],
      ),
    );
  }
}
