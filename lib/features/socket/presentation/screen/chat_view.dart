import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/features/socket/presentation/chat_bloc.dart';
import 'package:tradologie_app/features/socket/presentation/chat_event.dart';
import 'package:tradologie_app/features/socket/presentation/chat_state.dart';
import 'package:tradologie_app/features/socket/presentation/cubit/attachement_cubit.dart';
import 'package:tradologie_app/features/socket/presentation/screen/chat_input_bar.dart';
import 'package:tradologie_app/features/socket/presentation/screen/message_bubble.dart';
import 'package:tradologie_app/features/socket/presentation/screen/typing_indicator.dart';
import '../../../../injection_container.dart';

class ChatView extends StatefulWidget {
  final String myUserId;
  final String toUserId;
  final String role; // "Seller", "Buyer", etc. — passed to SignalR
  final String? recipientName;
  final String? recipientAvatarUrl;

  const ChatView({
    super.key,
    required this.myUserId,
    required this.toUserId,
    required this.role,
    this.recipientName,
    this.recipientAvatarUrl,
  });

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context
          .read<ChatBloc>()
          .add(ChatConnectEvent(widget.myUserId, role: widget.role));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom({bool animated = true}) {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        if (animated) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        } else {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChatBloc, ChatState>(
          listenWhen: (prev, curr) {
            if (curr is ChatConnected && prev is ChatConnected) {
              return curr.messages.length > prev.messages.length;
            }
            return false;
          },
          listener: (_, __) => _scrollToBottom(),
        ),
        BlocListener<AttachmentCubit, AttachmentState>(
          listener: (context, state) {
            if (state is AttachmentPicked) {
              final bloc = context.read<ChatBloc>();
              if (state.type == AttachmentPickType.pdf) {
                bloc.add(ChatSendPdfEvent(
                  toUser: widget.toUserId,
                  file: state.file,
                ));
              } else {
                bloc.add(ChatSendImageEvent(
                  toUser: widget.toUserId,
                  file: state.file,
                  fromCamera: state.type == AttachmentPickType.camera,
                ));
              }
              context.read<AttachmentCubit>().reset();
            } else if (state is AttachmentError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red.shade700,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.read<AttachmentCubit>().reset();
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            // Connection banner
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatConnecting) {
                  return const ConnectionBanner(
                    message: "Connecting...",
                    color: Colors.orange,
                  );
                } else if (state is ChatDisconnected) {
                  return ConnectionBanner(
                    message: state.reason ?? "Disconnected",
                    color: Colors.red,
                    showRetry: true,
                    onRetry: () => context.read<ChatBloc>().add(
                        ChatConnectEvent(widget.myUserId, role: widget.role)),
                  );
                } else if (state is ChatError) {
                  return ConnectionBanner(
                    message: state.message,
                    color: Colors.red,
                    showRetry: true,
                    onRetry: () => context.read<ChatBloc>().add(
                        ChatConnectEvent(widget.myUserId, role: widget.role)),
                  );
                }
                return const SizedBox.shrink();
              },
            ),

            // Messages list
            Expanded(
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatConnecting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is! ChatConnected) {
                    return const Center(
                      child: Text(
                        "Not connected",
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  final messages = state.messages;

                  if (messages.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.chat_bubble_outline,
                              size: 64, color: Colors.grey),
                          SizedBox(height: 12),
                          Text(
                            "No messages yet\nSay hello! 👋",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: messages.length + (state.isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (state.isTyping && index == messages.length) {
                        return const TypingIndicator();
                      }
                      final msg = messages[index];
                      // final showDate = index == 0 ||
                      //     !_isSameDay(
                      //       messages[index - 1].timestamp,
                      //       msg.timestamp,
                      //     );
                      return Column(
                        children: [
                          // if (showDate) _DateDivider(date: msg.timestamp),
                          MessageBubble(message: msg),
                        ],
                      );
                    },
                  );
                },
              ),
            ),

            // Input bar
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                final isConnected = state is ChatConnected;
                final isRecording = state is ChatConnected && state.isRecording;
                final recordDuration =
                    state is ChatConnected ? state.recordingDuration : null;

                return ChatInputBar(
                  toUserId: widget.toUserId,
                  enabled: isConnected,
                  isRecording: isRecording,
                  recordingDuration: recordDuration,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Returns the first character uppercased, or "?" if the string is empty.
  String _safeInitial(String value) =>
      value.isEmpty ? "?" : value[0].toUpperCase();

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.blue.shade100,
            backgroundImage: widget.recipientAvatarUrl != null
                ? NetworkImage(widget.recipientAvatarUrl!)
                : null,
            child: widget.recipientAvatarUrl == null
                ? Text(
                    _safeInitial(widget.recipientName ?? widget.toUserId),
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.recipientName ?? "User ${widget.toUserId}",
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is ChatConnected && state.isTyping) {
                    return const Text(
                      "typing...",
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    );
                  }
                  if (state is ChatConnected) {
                    return const Text(
                      "Online",
                      style: TextStyle(fontSize: 12, color: Colors.green),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: Colors.black),
          onPressed: () {},
        ),
      ],
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _DateDivider extends StatelessWidget {
  final DateTime date;
  const _DateDivider({required this.date});

  String _format(DateTime d) {
    final now = DateTime.now();
    if (d.year == now.year && d.month == now.month && d.day == now.day) {
      return "Today";
    }
    final yesterday = now.subtract(const Duration(days: 1));
    if (d.year == yesterday.year &&
        d.month == yesterday.month &&
        d.day == yesterday.day) {
      return "Yesterday";
    }
    return "${d.day}/${d.month}/${d.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              _format(date),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class ChatPage extends StatelessWidget {
  final String myUserId;
  final String toUserId;
  final String? recipientName;

  final String role;

  ChatPage({
    super.key,
    this.myUserId = "1",
    this.toUserId = "2",
    this.recipientName,
    this.role = "Seller", // set to your app's actual role
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // sl<ChatBloc>() calls the factory — fresh instance per page
        BlocProvider<ChatBloc>(
          create: (_) => sl<ChatBloc>(),
        ),
        BlocProvider<AttachmentCubit>(
          create: (_) => sl<AttachmentCubit>(),
        ),
      ],
      child: ChatView(
        myUserId: myUserId,
        toUserId: toUserId,
        recipientName: recipientName ?? "User $toUserId",
        role: 'seller',
      ),
    );
  }
}
