import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';

class CommonLoader extends StatelessWidget {
  const CommonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black.withValues(alpha: 0.1),
        child: Center(child: SpinKitCircle(color: AppColors.primary)));
  }
}
