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
import 'package:tradologie_app/core/widgets/common_fmcg_appbar.dart';
import 'package:tradologie_app/core/widgets/common_loader.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/app/injection_container_app.dart';
import 'package:tradologie_app/features/fmcg/domain/entities/chat_list.dart';
import 'package:tradologie_app/features/fmcg/domain/usecases/chat_list_usecase.dart';
import 'package:tradologie_app/features/fmcg/presentation/cubit/chat_cubit.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/chat_screen.dart';
import 'package:tradologie_app/features/fmcg/presentation/screens/fmcg_distributor_enq.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen>
    with SingleTickerProviderStateMixin {
  List<ChatList>? chatList;

  ChatCubit get chatCubit => BlocProvider.of(context);
  SecureStorageService secureStorage = SecureStorageService();

  void getChatList() async {
    ChatListParams params = ChatListParams(
      sellerID: await secureStorage.read(AppStrings.loginId) ?? "",
      token: await secureStorage.read(AppStrings.apiVerificationCode) ?? "",
      deviceID: Constants.deviceID,
    );

    await chatCubit.getChatList(params);
  }

  @override
  void initState() {
    super.initState();
    getChatList();
  }

  Future<void> _refreshChats() async {
    getChatList(); // your API call
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
            // CommonToast.showFailureToast(state.failure);
          }
        },
        child: Stack(
          children: [
            BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return RefreshIndicator(
                  onRefresh: _refreshChats,
                  child: CustomScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    slivers: [
                      /// App Bar
                      CommonSliverAppBar(
                        title: "Chats",
                        showSearch: false,
                      ),
                      // CommonAppbar(
                      //   title: "Chats",
                      //   showBackButton: false,
                      //   showNotification: false,
                      //   showSuffixIcon: true,
                      //   suffixIcon: Row(
                      //     mainAxisAlignment: MainAxisAlignment.end,
                      //     crossAxisAlignment: CrossAxisAlignment.end,
                      //     children: [
                      //       IconButton(
                      //           onPressed: () async {
                      //             await _refreshChats();
                      //           },
                      //           icon: Icon(
                      //             Icons.refresh,
                      //             color: Colors.green,
                      //           )),
                      //     ],
                      //   ),
                      // ),
                      ChatListSliver(
                        items: chatList ?? [],
                        onToggle: (i) async {
                          final shouldRefresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChatScreen(
                                chat: chatList?[i] ?? ChatList(),
                              ),
                            ),
                          );

                          if (shouldRefresh == true) {
                            await _refreshChats();
                          }
                        },
                      ),

                      /// Chat List
                      // SliverPadding(
                      //   padding: const EdgeInsets.symmetric(
                      //       horizontal: 12, vertical: 8),
                      //   sliver: SliverList(
                      //     delegate: SliverChildBuilderDelegate(
                      //       (context, index) {
                      //         final chat = chatList?[index];

                      //         return Padding(
                      //           padding: const EdgeInsets.only(bottom: 10),
                      //           child: Material(
                      //             color: Colors.white,
                      //             borderRadius: BorderRadius.circular(16),
                      //             elevation: 1,
                      //             child: InkWell(
                      //               borderRadius: BorderRadius.circular(16),
                      //               onTap: () async {
                      //                 final shouldRefresh =
                      //                     await Navigator.push(
                      //                   context,
                      //                   MaterialPageRoute(
                      //                     builder: (_) => ChatScreen(
                      //                       chat: chat ?? ChatList(),
                      //                     ),
                      //                   ),
                      //                 );

                      //                 if (shouldRefresh == true) {
                      //                   await _refreshChats();
                      //                 }
                      //               },
                      //               child: Padding(
                      //                 padding: const EdgeInsets.symmetric(
                      //                   horizontal: 14,
                      //                   vertical: 12,
                      //                 ),
                      //                 child: Row(
                      //                   children: [
                      //                     const SizedBox(width: 12),

                      //                     /// Name + Message
                      //                     Expanded(
                      //                       child: Column(
                      //                         crossAxisAlignment:
                      //                             CrossAxisAlignment.start,
                      //                         children: [
                      //                           Row(
                      //                             children: [
                      //                               Text(
                      //                                 chat?.name ?? "",
                      //                                 style: TextStyleConstants
                      //                                     .semiBold(context),
                      //                               ),
                      //                               Text(
                      //                                 " - ${chat?.mobile}",
                      //                                 style: TextStyleConstants
                      //                                     .semiBold(context),
                      //                               ),
                      //                             ],
                      //                           ),
                      //                           const SizedBox(height: 4),
                      //                           Text(
                      //                             DateTime.parse(
                      //                                     chat?.chatInsertedDate ??
                      //                                         "")
                      //                                 .dateTimeFormat,
                      //                             maxLines: 1,
                      //                             overflow:
                      //                                 TextOverflow.ellipsis,
                      //                             style: TextStyleConstants
                      //                                     .medium(context)
                      //                                 .copyWith(
                      //                                     color:
                      //                                         Colors.grey[600]),
                      //                           ),
                      //                         ],
                      //                       ),
                      //                     ),

                      //                     /// Time + unread
                      //                     Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.end,
                      //                       children: [
                      //                         Icon(
                      //                           Icons.keyboard_arrow_right,
                      //                         ),
                      //                         const SizedBox(height: 6),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         );
                      //       },
                      //       childCount: chatList?.length ?? 0,
                      //     ),
                      //   ),
                      // )
                    ],
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
          ],
        ),
      ),
    );
  }
}

class ChatRow extends StatelessWidget {
  final ChatList enquiry;

  final VoidCallback onTap;

  const ChatRow({
    super.key,
    required this.enquiry,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String getInitial(String? name) {
      if (name == null || name.trim().isEmpty) {
        return '?'; // fallback icon letter
      }
      return name.trim()[0].toUpperCase();
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Collapsed row ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                // Monogram — just text on white, framed by a very faint ring
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: T.faint, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      getInitial(enquiry.name),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: T.ink,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                "${enquiry.name ?? ""} - ${enquiry.mobile ?? ""}",
                                style: T.title,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                DateTime.parse(enquiry.chatInsertedDate ?? "")
                                    .dateTimeFormat,
                                style: T.body,
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Chevron
                const Icon(Icons.chevron_right, size: 16, color: T.muted),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatListSliver extends StatelessWidget {
  final List<ChatList> items;

  final ValueChanged<int> onToggle;

  const ChatListSliver({
    super.key,
    required this.items,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SliverFillRemaining(
        child: Center(child: Text('Nothing here yet', style: T.body)),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, i) {
          return Column(
            children: [
              ChatRow(
                enquiry: items[i],
                onTap: () => onToggle(i),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Divider(
                  height: 0,
                  thickness: 0.5,
                  color: T.faint,
                ),
              ),
            ],
          );
        },
        childCount: items.length,
      ),
    );
  }
}
