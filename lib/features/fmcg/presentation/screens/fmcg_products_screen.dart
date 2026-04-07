import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/features/dashboard/presentation/widgets/buyer_banner_engine.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_initial_chat_id_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/nav_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/chat_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/get_products_list.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/get_products_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';

class ProductsListParams {
  final String brandId;
  final String brandName;

  ProductsListParams({required this.brandId, required this.brandName});
}

class FmcgProductsScreen extends StatefulWidget {
  final ProductsListParams params;
  const FmcgProductsScreen({super.key, required this.params});

  @override
  State<FmcgProductsScreen> createState() => _FmcgProductsScreenState();
}

class _FmcgProductsScreenState extends State<FmcgProductsScreen>
    with SingleTickerProviderStateMixin {
  List<GetProductsList>? productsList;
  SecureStorageService secureStorage = SecureStorageService();

  bool _isChatOpen = false;

  // ── FAB pulse animation ────────────────────────────────────────────────────
  late AnimationController _fabPulseController;
  late Animation<double> _fabPulseAnimation;

  ChatCubit get chatCubit => BlocProvider.of(context);

  @override
  void initState() {
    super.initState();
    getProductsList();

    _fabPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _fabPulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _fabPulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabPulseController.dispose();
    super.dispose();
  }

  void getProductsList({String search = ""}) async {
    GetProductsListParams params = GetProductsListParams(
      token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "",
      deviceId: Constants.deviceID,
      brandId: widget.params.brandId,
    );
    await chatCubit.getProductsList(params);
  }

  Future<void> _refreshChats() async => getProductsList();

  void _toggleChat() {
    setState(() => _isChatOpen = !_isChatOpen);
    if (_isChatOpen) {
      _fabPulseController.stop();
    } else {
      _fabPulseController.repeat(reverse: true);
    }
  }

  ChatList selectedChat = ChatList();

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is ProductsListSuccess) {
            setState(() => productsList = state.data);
          }
          if (state is GetInitialChatIdSuccess) {
            selectedChat.sellerId = state.data.sellerId.toString();
            selectedChat.quotationUserId =
                await secureStorage.read(AppStrings.loginId) ?? "";
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(
                  chat: selectedChat,
                ),
              ),
            );
          }
          if (state is GetInitialChatIdError) {
            // CommonToast.showFailureToast(state.failure);
          }
        },
        child: SafeArea(
          top: false,
          child: Stack(
            children: [
              // ── Product Grid ───────────────────────────────────────────────
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: _refreshChats,
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        CommonAppbar(
                          title: widget.params.brandName,
                          showBackButton: true,
                          showNotification: false,
                        ),
                        SliverToBoxAdapter(child: const SizedBox(height: 16)),
                        SliverToBoxAdapter(
                          child: BuyerDashboardBannerEngine(
                            banners: [
                              AppBanner(
                                image:
                                    "https://www.tradologie.com/DOCS/mobileapp/${widget.params.brandId}/banner1.webp",
                                title: "",
                                subtitle: "",
                              ),
                              AppBanner(
                                image:
                                    "https://www.tradologie.com/DOCS/mobileapp/${widget.params.brandId}/banner2.webp",
                                title: "",
                                subtitle: "",
                              ),
                              AppBanner(
                                image:
                                    "https://www.tradologie.com/DOCS/mobileapp/${widget.params.brandId}/banner3.webp",
                                title: "",
                                subtitle: "",
                              ),
                            ],
                          ),
                        ),
                        SliverToBoxAdapter(child: const SizedBox(height: 16)),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                          sliver: SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.7,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => productCard(
                                productsList?[i] ?? GetProductsList(),
                                widget.params.brandName,
                                widget.params.brandId,
                              ),
                              childCount: productsList?.length ?? 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // ── Loading overlay ────────────────────────────────────────────
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  if (state is ProductsListIsLoading ||
                      state is GetInitialChatIdIsLoading) {
                    return const Positioned.fill(child: CommonLoader());
                  }
                  return const SizedBox.shrink();
                },
              ),

              // ── Chatbot Popup ──────────────────────────────────────────────
              AnimatedPositioned(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                right: 16,
                bottom: _isChatOpen
                    ? MediaQuery.of(context).size.height * 0.10
                    : -500,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 280),
                  opacity: _isChatOpen ? 1.0 : 0.0,
                  child: IgnorePointer(
                    ignoring: !_isChatOpen,
                    child: _ChatbotPopup(
                      chatbotUrl:
                          "https://www.tradologie.com/AIChatbotView?BrandID=${widget.params.brandId}",
                      onDirectConnect: () {
                        setState(() {
                          _isChatOpen = false;
                          context.read<NavigationCubit>().goToChat();
                        }); // 👈 CLOSE FAB
                      },
                    ),
                  ),
                ),
              ),

              // ── FAB ────────────────────────────────────────────────────────
              Positioned(
                right: 20,
                bottom: 10,
                child: _buildChatFab(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatFab() {
    return AnimatedBuilder(
      animation: _fabPulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _isChatOpen ? 1.0 : _fabPulseAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: _toggleChat,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5B6EE8), Color(0xFF3A4FD6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(_isChatOpen ? 18 : 29),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3A4FD6).withValues(alpha: 0.45),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: _isChatOpen
                ? const Icon(Icons.close_rounded,
                    key: ValueKey('close'), color: Colors.white, size: 26)
                : ClipOval(
                    child: Image.asset(
                      "assets/images/chatbot-icon.webp",
                      width: 58,
                      height: 58,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget productCard(
      GetProductsList enquiry, String brandName, String brandId) {
    return SizedBox.expand(
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedNetworkImage(
                    imageUrl: enquiry.productImageUrl ?? "",
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const SizedBox(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                enquiry.productName ?? "—",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2B2B2B),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    selectedChat.brandId = brandId.toString();
                    selectedChat.userId = brandName;

                    chatCubit.getInitialChatId(GetInitialChatIdParams(
                      token: await secureStorage
                              .read(AppStrings.apiVerificationCode) ??
                          "",
                      deviceId: Constants.deviceID,
                      buyerId:
                          await secureStorage.read(AppStrings.loginId) ?? "",
                      brandId: brandId.toString(),
                    ));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF2DAAE1),
                          Color(0xFF1B8ED1),
                        ],
                      ),
                    ),
                    child: const Text(
                      "Enquire Now",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Chatbot Popup with embedded WebView ───────────────────────────────────────

class _ChatbotPopup extends StatefulWidget {
  final String chatbotUrl;
  final VoidCallback? onDirectConnect;
  const _ChatbotPopup({required this.chatbotUrl, this.onDirectConnect});

  @override
  State<_ChatbotPopup> createState() => _ChatbotPopupState();
}

class _ChatbotPopupState extends State<_ChatbotPopup> {
  late final WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = AndroidWebViewControllerCreationParams();
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _webViewController = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(false)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            final url = request.url;

            debugPrint("🌐 URL: $url");

            if (url.contains("direct-connect")) {
              widget.onDirectConnect?.call(); // 👈 CLOSE FAB
              return NavigationDecision.prevent; // optional (stop loading)
            }

            return NavigationDecision.navigate;
          },
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onWebResourceError: (error) {
            debugPrint('❌ Chatbot WebView error: ${error.description}');
            setState(() => _isLoading = false);
          },
        ),
      );
    _webViewController.clearCache();
    _webViewController.clearLocalStorage();

    _webViewController.loadRequest(
      Uri.parse(_getFreshUrl(widget.chatbotUrl)),
      headers: {
        "Cache-Control": "no-cache, no-store, must-revalidate",
        "Pragma": "no-cache",
        "Expires": "0",
      },
    );

    // Android file picker handler (mirrors your WebViewScreen)
    if (_webViewController.platform is AndroidWebViewController) {
      (_webViewController.platform as AndroidWebViewController)
          .setOnShowFileSelector((_) async => []);
    }
  }

  String _getFreshUrl(String url) {
    final uri = Uri.parse(url);
    final newUri = uri.replace(
      queryParameters: {
        ...uri.queryParameters,
        't': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );
    return newUri.toString();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final popupWidth = (screenWidth - 32).clamp(0.0, 340.0);

    return Material(
      elevation: 12,
      borderRadius: BorderRadius.circular(20),
      shadowColor: Colors.black26,
      child: SizedBox(
        width: popupWidth,
        height: 480,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              // ── WebView ─────────────────────────────────────────────────
              Expanded(
                child: Stack(
                  children: [
                    WebViewWidget(controller: _webViewController),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3A4FD6),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
