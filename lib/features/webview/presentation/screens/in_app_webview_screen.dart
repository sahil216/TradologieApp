import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';

import '../../../../injection_container.dart';
import '../cubit/webview_cubit.dart';
import '../../../../core/widgets/common_loader.dart';
import 'viewmodel/webview_params.dart';

class InAppWebViewScreen extends StatefulWidget {
  final WebviewParams params;

  const InAppWebViewScreen({
    super.key,
    required this.params,
  });

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  @override
  void initState() {
    super.initState();
    _screenController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _screenFade = CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    );

    _screenScale = Tween<double>(
      begin: 0.97,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    _screenSlide = Tween<Offset>(
      begin: const Offset(0, .04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _screenController,
      curve: Curves.easeOutCubic,
    ));

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _screenController.forward();
    });
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.params.canPop ?? false,
      child: AdaptiveScaffold(
        // drawer: widget.params.isShowDrawer == true ? TradologieDrawer() : null,
        // appBar: widget.params.isAppBar == true
        //     ? Constants.appBar(context,
        //         centerTitle: true,
        //         boxShadow: [],
        //         actions: [
        //           widget.params.isShowNotification == true
        //               ? IconButton(
        //                   onPressed: () {
        //                     sl<NavigationService>().pushNamed(
        //                       Routes.notificationScreen,
        //                     );
        //                   },
        //                   icon: Icon(Icons.notifications))
        //               : SizedBox.shrink(),
        //           SizedBox(width: 10),
        //         ],
        //         titleWidget: Image.asset(ImgAssets.companyLogo, height: 40))
        //     : null,
        body: Stack(
          children: [
            FadeTransition(
                opacity: _screenFade,
                child: SlideTransition(
                    position: _screenSlide,
                    child: ScaleTransition(
                        scale: _screenScale,
                        child: CustomScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          slivers: [
                            /// 💎 COMMON SLIVER APPBAR
                            if (widget.params.isAppBar == true)
                              CommonAppbar(
                                title: "Account",
                                showBackButton: widget.params.canPop ?? false,
                                showNotification:
                                    widget.params.isShowNotification,
                                showLogo: true,
                                onNotificationTap: () {
                                  sl<NavigationService>().pushNamed(
                                    Routes.notificationScreen,
                                  );
                                },
                              ),

                            /// 🌐 WEBVIEW BODY
                            SliverFillRemaining(
                              hasScrollBody: true,
                              child: InAppWebView(
                                initialUrlRequest: URLRequest(
                                  url: WebUri(widget.params.url),
                                ),
                                initialSettings: InAppWebViewSettings(
                                  javaScriptEnabled: true,
                                  domStorageEnabled: true,
                                  useHybridComposition: true,
                                  mediaPlaybackRequiresUserGesture: false,
                                ),
                                onReceivedServerTrustAuthRequest:
                                    (controller, challenge) async {
                                  return ServerTrustAuthResponse(
                                    action:
                                        ServerTrustAuthResponseAction.PROCEED,
                                  );
                                },
                                onLoadStart: (controller, url) {
                                  context
                                      .read<WebViewCubit>()
                                      .onPageStarted(url.toString());
                                },
                                onLoadStop: (controller, url) {
                                  context
                                      .read<WebViewCubit>()
                                      .onPageFinished(url.toString());
                                },
                              ),
                            ),
                          ],
                        )))),
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
    );
  }
}
