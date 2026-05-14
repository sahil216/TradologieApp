import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shows a confirmation dialog; on Yes, closes the Flutter activity (exit app).
Future<void> showExitAppConfirmationDialog(BuildContext context) async {
  if (!context.mounted) return;
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: const Text('Exit app'),
      content: const Text('Do you want to exit the app?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text('Yes'),
        ),
      ],
    ),
  );
  if (result == true && context.mounted) {
    SystemNavigator.pop();
  }
}
