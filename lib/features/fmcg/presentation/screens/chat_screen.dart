import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/utils/app_strings.dart';
import 'package:tradologie_app/core/utils/constants.dart';
import 'package:tradologie_app/core/utils/hex_color.dart';
import 'package:tradologie_app/core/utils/secure_storage_service.dart';
import 'package:tradologie_app/core/widgets/adaptive_scaffold.dart';
import 'package:tradologie_app/core/widgets/common_appbar.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_data.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_data_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_distributor_enq.dart';

class ChatScreen extends StatefulWidget {
  final ChatList chat;

  const ChatScreen({super.key, required this.chat});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  TextEditingController controller = TextEditingController();

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
      getData("", "0");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    } finally {
      _isFetching = false;
    }
  }

  void getData(String? message, String? chatId) async {
    token = await secureStorage.read(AppStrings.apiVerificationCode) ?? "";
    loginId = await secureStorage.read(AppStrings.loginId) ?? "";
    ChatDataParams params = ChatDataParams(
      token: token,
      contents: message ?? "",
      chatID: chatId ?? "0",
      buyerID: widget.chat.quotationUserId ?? "",
      sellerID: loginId,
      deviceID: Constants.deviceID,
    );

    chatCubit.chatData(params);
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    getData("", "0");
    _startPolling();
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
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = HexColor('#0A84FF');
    final sentBubbleColor = primaryColor;
    final receivedBubbleColor = Colors.white;
    final pageBg = const Color(0xffF4F7FB);

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
        child: SafeArea(
          child: Stack(
            children: [
              BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
                return Column(
                  children: [
                    ChatTopBar(
                      name: widget.chat.name ?? "",
                      imageUrl: "",
                      notificationCount: 2,
                      isOnline:
                          widget.chat.loginStatus?.toLowerCase() == "online"
                              ? true
                              : false,
                      onBackTap: () {
                        Navigator.pop(context);
                      },
                      onNotificationTap: () {},
                    ),
                    Expanded(
                      child: CustomScrollView(
                        controller: _scrollController,
                        physics: const BouncingScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(14, 10, 14, 90),
                            sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final msg = chatData?[index];
                                  final isMe =
                                      msg?.msgType?.toLowerCase() == "seller"
                                          ? true
                                          : false;

                                  Map<String, dynamic>? data;

                                  try {
                                    if (msg?.msgContent != null &&
                                        (msg?.msgContent ?? "").isNotEmpty) {
                                      data = jsonDecode(msg!.msgContent!);
                                    }
                                  } catch (e) {
                                    data = null;
                                  }

                                  return Column(
                                    children: [
                                      if ((msg?.displayDate ?? "").isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          child: Center(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 7,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                border: Border.all(
                                                  color: Colors.black12,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(
                                                            alpha: 0.04),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                msg?.displayDate ?? "",
                                                style:
                                                    TextStyleConstants.medium(
                                                  context,
                                                  fontSize: 11,
                                                  color: Colors.grey.shade700,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      Align(
                                        alignment: isMe
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.74,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 14,
                                                vertical: 12,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isMe
                                                    ? sentBubbleColor
                                                    : receivedBubbleColor,
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      const Radius.circular(18),
                                                  topRight:
                                                      const Radius.circular(18),
                                                  bottomLeft: Radius.circular(
                                                      isMe ? 18 : 4),
                                                  bottomRight: Radius.circular(
                                                      isMe ? 4 : 18),
                                                ),
                                                boxShadow: [
                                                  // BoxShadow(
                                                  //   color: Colors.black
                                                  //       .withValues(alpha: 0.06),
                                                  //   blurRadius: 10,
                                                  //   offset: const Offset(0, 3),
                                                  // ),
                                                ],
                                                border: isMe
                                                    ? null
                                                    : Border.all(
                                                        color: Colors.black12,
                                                      ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: isMe
                                                    ? CrossAxisAlignment.end
                                                    : CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    data?["Message"] ?? "",
                                                    style: TextStyleConstants
                                                        .medium(
                                                      context,
                                                      color: isMe
                                                          ? Colors.white
                                                          : const Color(
                                                              0xff1F2937),
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Text(
                                                    msg?.displayTime ?? "",
                                                    style: TextStyleConstants
                                                        .medium(
                                                      context,
                                                      color: isMe
                                                          ? Colors.white70
                                                          : Colors
                                                              .grey.shade600,
                                                      fontSize: 11,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                childCount: chatData?.length ?? 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Message Input Bar
                    SafeArea(
                      top: false,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 14,
                              offset: const Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffF3F5F7),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: Colors.black12,
                                  ),
                                ),
                                child: TextField(
                                  controller: controller,
                                  minLines: 1,
                                  maxLines: 4,
                                  textInputAction: TextInputAction.send,
                                  decoration: InputDecoration(
                                    hintText: "Type your message...",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade500,
                                      fontSize: 15,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (_) {
                                    setState(() {
                                      getData(
                                        controller.text.isEmpty
                                            ? null
                                            : controller.text,
                                        chatData?.last.chatId.toString(),
                                      );
                                      controller.clear();
                                      WidgetsBinding.instance
                                          .addPostFrameCallback((_) {
                                        _scrollToBottom();
                                      });
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  getData(
                                    controller.text.isEmpty
                                        ? null
                                        : controller.text,
                                    chatData?.last.chatId.toString(),
                                  );
                                  controller.clear();
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    _scrollToBottom();
                                  });
                                });
                              },
                              child: Container(
                                height: 52,
                                width: 52,
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          primaryColor.withValues(alpha: 0.28),
                                      blurRadius: 12,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
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
      ),
    );
  }
}

class DateHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String date;

  DateHeaderDelegate(this.date);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          date,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class ChatTopBar extends StatelessWidget {
  final String name;
  final String imageUrl;
  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;
  final bool isOnline;
  final int notificationCount;

  const ChatTopBar({
    super.key,
    required this.name,
    required this.imageUrl,
    this.onBackTap,
    this.onNotificationTap,
    this.isOnline = true,
    this.notificationCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    String getInitial(String? name) {
      if (name == null || name.trim().isEmpty) {
        return '?'; // fallback icon letter
      }
      return name.trim()[0].toUpperCase();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBackTap,
            behavior: HitTestBehavior.opaque,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 20,
              color: Color(0xFF0A2A52),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade300,
                        border: Border.all(color: T.faint, width: 1),
                      ),
                      child: Center(
                        child: Text(
                          getInitial(name),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: -1,
                        bottom: 2,
                        child: Container(
                          height: 16,
                          width: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6ACB1B),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
