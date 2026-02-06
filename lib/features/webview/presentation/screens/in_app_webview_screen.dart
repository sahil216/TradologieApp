import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/app/presentation/screens/drawer.dart';

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

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.params.canPop ?? false,
      child: AdaptiveScaffold(
        drawer: widget.params.isShowDrawer == true ? TradologieDrawer() : null,
        appBar: widget.params.isAppBar == true
            ? Constants.appBar(context,
                elevation: 0,
                centerTitle: true,
                boxShadow: [],
                actions: [
                  widget.params.isShowNotification == true
                      ? IconButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, Routes.notificationScreen);
                          },
                          icon: Icon(Icons.notifications))
                      : SizedBox.shrink(),
                  SizedBox(width: 10),
                ],
                titleWidget: Image.asset(ImgAssets.companyLogo, height: 40))
            : null,
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(widget.params.url),
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                useHybridComposition: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
              onReceivedServerTrustAuthRequest: (controller, challenge) async {
                return ServerTrustAuthResponse(
                  action: ServerTrustAuthResponseAction.PROCEED,
                );
              },
              onLoadStart: (controller, url) {
                context.read<WebViewCubit>().onPageStarted(url.toString());
              },
              onLoadStop: (controller, url) {
                context.read<WebViewCubit>().onPageFinished(url.toString());
              },
            ),
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
