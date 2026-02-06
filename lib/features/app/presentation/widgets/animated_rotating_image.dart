import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';

class CircularImageRotator extends StatefulWidget {
  const CircularImageRotator({super.key});

  @override
  State<CircularImageRotator> createState() => _CircularImageRotatorState();
}

class _CircularImageRotatorState extends State<CircularImageRotator> {
  Timer? _timer;

  List<String> images = [
    ImgAssets.getStratedLogo1, // slot 1
    ImgAssets.getStratedLogo2, // slot 2
    ImgAssets.getStratedLogo3, // slot 3
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        // 🔁 Rotate images (1 → 3, 3 → 2, 2 → 1)
        images = [
          images[1],
          images[2],
          images[0],
        ];
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildSlot(String imagePath) {
    return SizedBox(
      width: 120,
      height: 130,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: ClipOval(
          key: ValueKey(imagePath), // 🔥 critical for switcher
          child: Image.asset(
            imagePath,
            width: 180,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildSlot(images[0]),
          _buildSlot(images[1]),
          _buildSlot(images[2]),
        ],
      ),
    );
  }
}
