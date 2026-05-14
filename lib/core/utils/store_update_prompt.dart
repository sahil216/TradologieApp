import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Must match the app id published on Google Play (`applicationId` in Android).
const String _androidPlayStoreId = 'com.tradologie.app';

/// Compares this install to Play Store / App Store and shows an update dialog when
/// the listing version is higher. Fails silently on errors or unsupported platforms.
Future<void> promptStoreUpdateIfAvailable(BuildContext context) async {
  if (kIsWeb || (!Platform.isAndroid && !Platform.isIOS)) return;

  final newVersion = NewVersionPlus(
    androidId: _androidPlayStoreId,
  );

  try {
    final status = await newVersion.getVersionStatus();
    if (status == null || !status.canUpdate) return;
    if (!context.mounted) return;

    final link = status.appStoreLink;
    if (link.isEmpty) return;

    final body =
        'A new version of the app ${status.storeVersion} is available with the latest improvements, performance enhancements. Please update the app to continue enjoying the best experience.';

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        Future<void> openStore() async {
          final uri = Uri.parse(link);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
          if (ctx.mounted) Navigator.of(ctx).pop();
        }

        if (Platform.isAndroid) {
          return PopScope(
            canPop: true,
            child: AlertDialog(
              title: const Text('Update available'),
              content: Text(body),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Later'),
                ),
                TextButton(
                  onPressed: openStore,
                  child: const Text('Update'),
                ),
              ],
            ),
          );
        }

        return PopScope(
          canPop: true,
          child: CupertinoAlertDialog(
            title: const Text('Update available'),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                onPressed: openStore,
                child: const Text('Update'),
              ),
              CupertinoDialogAction(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Later'),
              ),
            ],
          ),
        );
      },
    );
  } catch (e, st) {
    debugPrint('promptStoreUpdateIfAvailable: $e\n$st');
  }
}
