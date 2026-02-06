import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
    return Stack(
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

          /// ⚠️ TEMPORARY — REMOVE AFTER SSL FIX
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

          onLoadError: (controller, url, code, message) {
            debugPrint('❌ InAppWebView error: $code $message');
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
    );
  }
}
