import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/error/failures.dart';
import 'package:tradologie_app/core/error/network_failure.dart';
import 'package:tradologie_app/core/error/user_failure.dart';
import 'package:tradologie_app/core/widgets/custom_text/common_text_widget.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';

import '../../injection_container.dart';

class CommonToast {
  CommonToast._();

  static OverlayEntry? _entry;
  static final List<ToastJob> _queue = [];
  static bool _showing = false;

  /// ===============================
  /// PUBLIC API
  /// ===============================

  static void success(String msg) {
    _add(ToastJob(
      message: msg,
      icon: Icons.check_circle_outline_rounded,
      color: Colors.green,
      duration: const Duration(seconds: 4),
      priority: ToastPriority.normal,
    ));
  }

  static void showFailureToast(Failure failure) {
    if (failure is NetworkFailure) {
      internetError();
    } else if (failure is UserFailure) {
      error(failure.msg ?? "An error occurred");
    } else {
      error("Something went wrong");
    }
  }

  static void error(String msg, {Color? color}) {
    _add(ToastJob(
      message: msg,
      icon: Icons.error_outline,
      color: color ?? Colors.red,
      duration: const Duration(seconds: 4),
      priority: ToastPriority.high,
    ));
  }

  static void internetError() {
    _add(ToastJob(
      message: "No internet connection",
      icon: Icons.wifi_off_outlined,
      color: Colors.black,
      duration: const Duration(seconds: 5),
      priority: ToastPriority.high,
    ));
  }

  static void normal(String msg) {
    _add(ToastJob(
      message: msg,
      icon: null,
      color: Colors.black87,
      duration: const Duration(seconds: 2),
      priority: ToastPriority.low,
    ));
  }

  /// ===============================
  /// QUEUE + PRIORITY ENGINE
  /// ===============================

  static void _add(ToastJob job) {
    if (job.priority == ToastPriority.high) {
      _queue.insert(0, job); // interrupt queue
    } else {
      _queue.add(job);
    }
    _next();
  }

  static void _next() {
    if (_showing || _queue.isEmpty) return;

    final overlay = _overlay;
    if (overlay == null) {
      debugPrint("❌ Overlay not ready");
      return;
    }

    _showing = true;
    final job = _queue.removeAt(0);

    _entry = OverlayEntry(
      builder: (_) => ToastBanner(
        job: job,
        onDismiss: _remove,
      ),
    );

    overlay.insert(_entry!);
  }

  static void _remove() {
    _entry?.remove();
    _entry = null;
    _showing = false;

    Future.delayed(const Duration(milliseconds: 150), _next);
  }

  /// ===============================
  /// ELITE OVERLAY ACCESS
  /// ===============================

  static OverlayState? get _overlay {
    final navKey = sl<NavigationService>().navigationKey;
    return navKey.currentState?.overlay;
  }
}

/// ===============================
/// TOAST DATA
/// ===============================

enum ToastPriority { low, normal, high }

class ToastJob {
  final String message;
  final IconData? icon;
  final Color color;
  final Duration duration;
  final ToastPriority priority;

  ToastJob({
    required this.message,
    required this.icon,
    required this.color,
    required this.duration,
    required this.priority,
  });
}

/// ===============================
/// TOAST BANNER WIDGET
/// ===============================

class ToastBanner extends StatefulWidget {
  final ToastJob job;
  final VoidCallback onDismiss;

  const ToastBanner({
    super.key,
    required this.job,
    required this.onDismiss,
  });

  @override
  State<ToastBanner> createState() => _ToastBannerState();
}

class _ToastBannerState extends State<ToastBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> slide;
  late Animation<double> fade;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    slide = Tween(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

    fade = Tween(begin: 0.0, end: 1.0).animate(controller);

    controller.forward();

    Future.delayed(widget.job.duration, dismiss);
  }

  void dismiss() async {
    if (!mounted) return;
    await controller.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final isIOS = Platform.isIOS;

    return Positioned(
      left: 12,
      right: 12,
      bottom: bottom + 12,
      child: SafeArea(
        top: false,
        child: SlideTransition(
          position: slide,
          child: FadeTransition(
            opacity: fade,
            child: GestureDetector(
              onVerticalDragUpdate: (d) {
                if ((d.primaryDelta ?? 0) > 6) dismiss();
              },
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: isIOS
                        ? widget.job.color.withValues(alpha: 0.92)
                        : widget.job.color,
                    borderRadius: BorderRadius.circular(isIOS ? 16 : 6),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 12,
                        offset: Offset(0, 4),
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (widget.job.icon != null)
                        Icon(widget.job.icon, color: Colors.white),
                      if (widget.job.icon != null) const SizedBox(width: 8),
                      Expanded(
                        child: CommonText(
                          widget.job.message,
                          style: TextStyleConstants.semiBold(
                            context,
                            color: Colors.white,
                            fontSize: isIOS ? 15 : 14,
                            fontWeight: FontWeight.w500,
                            decoration:
                                TextDecoration.none, // 🔥 force no underline
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: dismiss,
                        child: const Icon(Icons.close,
                            size: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
