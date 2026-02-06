import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:tradologie_app/core/utils/assets_manager.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/features/webview/presentation/cubit/webview_cubit.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/widgets/common_loader.dart';

class TermsScreen extends StatefulWidget {
  final String initialUrl;

  const TermsScreen({super.key, required this.initialUrl});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  late final WebViewController _controller;
  SecureStorageService secureStorage = SecureStorageService();

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
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
      ..loadRequest(Uri.parse(widget.initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      appBar: Constants.appBar(
        context,
        elevation: 0,
        boxShadow: [],
        centerTitle: true,
        titleWidget: Image.asset(
          ImgAssets.companyLogo,
          height: 40,
        ),
      ),
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
    );
  }
}
