import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/config/routes/app_router.dart';
import 'package:tradologie_app/config/routes/navigation_service.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';
import 'package:tradologie_app/features/chat/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/chat/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/chat/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/chat/presentation/cubit/chat_cubit.dart';

class ChatScreen extends StatefulWidget {
  final ChatList chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  late AnimationController _screenController;
  late Animation<double> _screenFade;
  late Animation<double> _screenScale;
  late Animation<Offset> _screenSlide;

  List<ChatData>? chatData;

  String token = "";
  String loginId = "";

  Timer? _timer;

  ChatCubit get chatCubit => BlocProvider.of(context);
  SecureStorageService secureStorage = SecureStorageService();

  void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchMessages();
    });
  }

  bool _isFetching = false;

  Future<void> fetchMessages() async {
    if (_isFetching) return;

    _isFetching = true;

    try {
      getData("");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _isFetching = false;
    }
  }

  void getData(String? message) async {
    token = await secureStorage.read(AppStrings.apiVerificationCode) ?? "";
    loginId = await secureStorage.read(AppStrings.loginId) ?? "";
    ChatDataParams params = ChatDataParams(
      token: token,
      contents: message ?? "",
      buyerID: widget.chat.quotationUserId ?? "",
      sellerID: loginId,
    );

    chatCubit.chatData(params);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getData("");
    _startPolling();

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

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;

    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _screenController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      body: BlocListener<ChatCubit, ChatState>(
        listenWhen: (previous, current) => previous != current,
        listener: (context, state) async {
          if (state is ChatDataSuccess) {
            setState(() {
              chatData = state.data;
            });

            /// scroll after UI rebuild
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
          }
          if (state is ChatDataError) {
            CommonToast.showFailureToast(state.failure);
          }
        },
        child: Stack(
          children: [
            BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: FadeTransition(
                      opacity: _screenFade,
                      child: SlideTransition(
                        position: _screenSlide,
                        child: ScaleTransition(
                          scale: _screenScale,
                          child: CustomScrollView(
                            controller: _scrollController,
                            slivers: [
                              /// App Bar
                              CommonAppbar(
                                title: widget.chat.name ?? "",
                                showBackButton: true,
                                showNotification: false,
                              ),

                              /// Messages
                              SliverPadding(
                                padding: const EdgeInsets.all(16),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final msg = chatData?[index];
                                      final isMe =
                                          msg?.msgType?.toLowerCase() ==
                                                  "seller"
                                              ? true
                                              : false;
                                      Map<String, dynamic> data =
                                          jsonDecode(msg?.msgContent ?? "");

                                      return Align(
                                        alignment: isMe
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: isMe
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(18),
                                          ),
                                          child: Text(
                                            data["Message"] ?? "",
                                            style: TextStyleConstants.medium(
                                              context,
                                              color: isMe
                                                  ? Colors.white
                                                  : Colors.black87,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: chatData?.length,
                                  ),
                                ),
                              ),

                              /// Bottom spacing
                              const SliverToBoxAdapter(
                                child: SizedBox(height: 80),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Message Input Bar
                  SafeArea(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: const BoxDecoration(
                        border: Border(top: BorderSide(color: Colors.black12)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                hintText: "Message",
                                filled: true,
                                fillColor: Colors.grey.shade100,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              setState(() {
                                getData(controller.text.isEmpty
                                    ? null
                                    : controller.text);
                                controller.clear();
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _scrollToBottom();
                                });
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
