import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommonLaunchButton extends StatelessWidget {
  final String url;
  final String text;
  final IconData? icon;
  final bool openExternal;
  final ButtonStyle? style;
  final TextStyle? textStyle;

  const CommonLaunchButton({
    super.key,
    required this.url,
    required this.text,
    this.icon,
    this.openExternal = true,
    this.style,
    this.textStyle,
  });

  Future<void> _launch() async {
    final uri = Uri.parse(url);

    if (!await canLaunchUrl(uri)) {
      debugPrint('Could not launch $url');
      return;
    }

    await launchUrl(
      uri,
      mode: openExternal
          ? LaunchMode.externalApplication
          : LaunchMode.inAppWebView,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launch,
      style: style,
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(text, style: textStyle),
              ],
            )
          : Text(text, style: textStyle),
    );
  }
}
