import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/features/app/presentation/screens/drawer.dart';
import 'package:tradologie_app/features/app/presentation/widgets/auto_refresh_mixin.dart';
import 'package:tradologie_app/features/webview/presentation/screens/viewmodel/webview_params.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import '../../../../core/utils/app_strings.dart';
import '../../../../injection_container.dart';
import '../cubit/webview_cubit.dart';

class WebViewScreen extends StatefulWidget {
  final WebviewParams params;

  const WebViewScreen({
    super.key,
    required this.params,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  SecureStorageService secureStorage = SecureStorageService();

  Future<bool> isAndroid13OrLower() async {
    if (!Platform.isAndroid) return false;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt <= 33; // Android 13 = API 33
  }

  @override
  void initState() {
    super.initState();
    debugPrint(widget.params.url);

    late final PlatformWebViewControllerCreationParams params;

    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            debugPrint('❌ WebView error: ${error.description}');
          },
          onPageStarted: (url) {
            context.read<WebViewCubit>().onPageStarted(url);
          },
          onPageFinished: (url) {
            context.read<WebViewCubit>().onPageFinished(url);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.params.url));

    /// 🚀 ANDROID FILE PICKER HANDLER
    if (_controller.platform is AndroidWebViewController) {
      final androidController =
          _controller.platform as AndroidWebViewController;

      androidController.setOnShowFileSelector(
        (FileSelectorParams params) async {
          return [];
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<WebViewCubit, WebViewState>(
      listener: (context, state) {
        if (state is SpecialPageDetected) {
          secureStorage.clear();

          Constants.isLogin = false;
          secureStorage.write(
            AppStrings.appSession,
            false.toString(),
          );

          Navigator.pushReplacementNamed(context, Routes.sendOtpScreen);
        }
      },
      child: PopScope(
        canPop: widget.params.canPop ?? false,
        child: AdaptiveScaffold(
          drawer:
              widget.params.isShowDrawer == true ? TradologieDrawer() : null,
          appBar: widget.params.isAppBar == true
              ? Constants.appBar(context,
                  elevation: 0,
                  centerTitle: true,
                  boxShadow: [],
                  actions: [
                    widget.params.isShowNotification == true
                        ? IconButton(
                            onPressed: () {
                              sl<NavigationService>().pushNamed(
                                Routes.notificationScreen,
                              );
                            },
                            icon: Icon(Icons.notifications))
                        : SizedBox.shrink(),
                    SizedBox(width: 10),
                  ],
                  titleWidget: Image.asset(ImgAssets.companyLogo, height: 40))
              : null,
          body: SafeArea(
            child: Stack(
              children: [
                WebViewWidget(controller: _controller),
                BlocBuilder<WebViewCubit, WebViewState>(
                  builder: (context, state) {
                    if (state is WebPageLoading) {
                      return const CommonLoader();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
