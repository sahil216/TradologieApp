import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/extensions.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';
import 'package:tradologie_app/features/app/presentation/screens/main_screen.dart';
import 'package:tradologie_app/features/chat/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/chat/domain/usecases/chat_list_usecase.dart';
import 'package:tradologie_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/chat/presentation/screens/chat_screen.dart';
import 'package:tradologie_app/features/chat/presentation/screens/fmcg_main_screen.dart';
import 'package:tradologie_app/features/chat/presentation/screens/fmcg_my_account_screen.dart';
import 'package:tradologie_app/features/chat/presentation/screens/fmcg_seller_dashboard_screen.dart';
import 'package:tradologie_app/features/contact_us/coming_soon_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  List<ChatList>? chatList;

  ChatCubit get chatCubit => BlocProvider.of(context);
  SecureStorageService secureStorage = SecureStorageService();

  void getChatList() async {
    ChatListParams params = ChatListParams(
      sellerID: await secureStorage.read(AppStrings.loginId) ?? "",
      token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "",
    );

    await chatCubit.getChatList(params);
  }

  @override
  void initState() {
    super.initState();
    getChatList();

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

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _screenController.forward();
    });
  }

  Future<void> _refreshChats() async {
    getChatList(); // your API call
  }

  @override
  void dispose() {
    _screenController.dispose();
    super.dispose();
  }

  int navIndex = 0;
  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is GetChatListSuccess) {
            chatList = state.data;
          }
          if (state is GetChatListError) {
            CommonToast.showFailureToast(state.failure);
          }
        },
        child: Stack(
          children: [
            if (navIndex == 0) FmcgSellerDashboardScreen(),
            if (navIndex == 1)
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return FadeTransition(
                    opacity: _screenFade,
                    child: SlideTransition(
                      position: _screenSlide,
                      child: ScaleTransition(
                        scale: _screenScale,
                        child: RefreshIndicator(
                          onRefresh: _refreshChats,
                          child: CustomScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            slivers: [
                              /// App Bar
                              CommonAppbar(
                                title: "Chats",
                                showBackButton: false,
                                showNotification: false,
                                showSuffixIcon: true,
                                suffixIcon: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await _refreshChats();
                                        },
                                        icon: Icon(
                                          Icons.refresh,
                                          color: Colors.green,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          CommonToast.success(
                                              "Signed Out Successfully");
                                          Constants.isLogin = false;
                                          Constants.isBuyer = false;
                                          Constants.isFmcg = false;

                                          SecureStorageService secureStorage =
                                              SecureStorageService();
                                          secureStorage
                                              .delete(AppStrings.isBuyer);

                                          secureStorage.delete(
                                              AppStrings.apiVerificationCode);
                                          Constants.token = "";

                                          secureStorage.write(
                                              AppStrings.appSession,
                                              false.toString());

                                          sl<NavigationService>()
                                              .pushNamedAndRemoveUntil(
                                            Routes.onboardingRoute,
                                          );
                                        },
                                        icon: Icon(Icons.logout,
                                            color: Colors.red)),
                                  ],
                                ),
                              ),

                              /// Chat List
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final chat = chatList?[index];

                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Material(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          elevation: 1,
                                          child: InkWell(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            onTap: () async {
                                              final shouldRefresh =
                                                  await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ChatScreen(
                                                    chat: chat ?? ChatList(),
                                                  ),
                                                ),
                                              );

                                              if (shouldRefresh == true) {
                                                await _refreshChats();
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 12,
                                              ),
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 12),

                                                  /// Name + Message
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              chat?.name ?? "",
                                                              style: TextStyleConstants
                                                                  .semiBold(
                                                                      context),
                                                            ),
                                                            Text(
                                                              " - ${chat?.mobile}",
                                                              style: TextStyleConstants
                                                                  .semiBold(
                                                                      context),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          DateTime.parse(
                                                                  chat?.chatInsertedDate ??
                                                                      "")
                                                              .dateTimeFormat,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyleConstants
                                                                  .medium(
                                                                      context)
                                                              .copyWith(
                                                                  color: Colors
                                                                          .grey[
                                                                      600]),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  /// Time + unread
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .keyboard_arrow_right,
                                                      ),
                                                      const SizedBox(height: 6),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: chatList?.length ?? 0,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is GetChatListIsLoading) {
                  return Positioned.fill(child: const CommonLoader());
                }
                return SizedBox.shrink();
              },
            ),
            CommonFMCGFloatingNavBar(
              index: navIndex,
              onTap: (i) {
                if (i == 2) {
                  Constants.launch(
                      "https://www.tradologie.com/brand-membership/");
                } else {
                  setState(() {
                    navIndex = i;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
