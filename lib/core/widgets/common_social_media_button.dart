import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class CommonSocialMediaButton extends StatelessWidget {
  final VoidCallback onTap;
  final String iconPath;
  const CommonSocialMediaButton(
      {super.key, required this.onTap, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.transparent,
          borderRadius: BorderRadius.circular(10), // Soft rounded corners
          boxShadow: [],
        ),
        child: Center(
          child: SizedBox(
            width: 45,
            height: 45,
            child: Image.asset(
              iconPath,
              width: 30,
              height: 30,
            ),
          ),
        ),
      ),
    );
  }
}
