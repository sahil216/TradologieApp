import 'package:flutter/cupertino.dart';

class CommonLoader extends StatelessWidget {
  const CommonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        /// 🔥 Blocks touches behind loader (iOS style)
        ModalBarrier(
          dismissible: false,
        ),

        /// 🍎 iOS native spinner
        Center(
          child: CupertinoActivityIndicator(
            radius: 20,
          ),
        ),
      ],
    );
  }
}
