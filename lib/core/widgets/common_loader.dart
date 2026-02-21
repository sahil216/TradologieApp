import 'package:flutter/cupertino.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';

class CommonLoader extends StatelessWidget {
  const CommonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        /// 🔥 Blocks touches behind loader (iOS style)
        ModalBarrier(
          dismissible: false,
        ),

        /// 🍎 iOS native spinner
        Center(
          child: CupertinoActivityIndicator(
            radius: 20,
            color: AppColors.black.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }
}
