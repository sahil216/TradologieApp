import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/core/navigation/admin_chat_route_observer.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/widgets/comon_toast_system.dart';
import 'package:tradologie_app/core/widgets/custom_text/text_style_constants.dart';
import 'package:tradologie_app/features/admin/presentation/cubit/admin_chat_cubit.dart';
import 'package:tradologie_app/features/admin/presentation/cubit/admin_chat_event.dart';
import 'package:tradologie_app/features/admin/presentation/cubit/admin_chat_state.dart';
import 'package:tradologie_app/features/admin/presentation/widgets/admin_chat_message_bubble.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';

class AdminChatView extends StatefulWidget {
  final String fromUserId;
  final String toUserId;
  final String apiCode;
  final String type1;
  final String type2;
  final String recipientName;
  final bool isConnectChat;
  final bool useTradologieBranding;
  final String? peerImageBase64;

  const AdminChatView({
    super.key,
    required this.fromUserId,
    required this.toUserId,
    required this.apiCode,
    required this.type1,
    required this.type2,
    required this.recipientName,
    this.isConnectChat = false,
    this.useTradologieBranding = false,
    this.peerImageBase64,
  });

  @override
  State<AdminChatView> createState() => _AdminChatViewState();
}

class _AdminChatViewState extends State<AdminChatView>
    with WidgetsBindingObserver, RouteAware {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  bool _wasPausedForLifecycle = false;
  bool _wasPausedForRoute = false;
  bool _isLeaving = false;
  bool _allowLifecyclePause = false;
  Timer? _resumeDebounce;
  Timer? _connectDebounce;
  Timer? _startupGuard;

  static const Duration _connectDebounceDuration =
      Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleConnect());
    _startupGuard = Timer(const Duration(milliseconds: 1500), () {
      _allowLifecyclePause = true;
    });
  }

  void _scheduleConnect() {
    if (_isLeaving || !mounted) return;
    _connectDebounce?.cancel();
    _connectDebounce = Timer(_connectDebounceDuration, () {
      if (_isLeaving || !mounted) return;
      _connect();
    });
  }

  void _cancelScheduledConnect() {
    _connectDebounce?.cancel();
    _connectDebounce = null;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) {
      adminChatRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted || !_allowLifecyclePause) return;
    final cubit = context.read<AdminChatCubit>();

    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _resumeDebounce?.cancel();
        if (!_wasPausedForLifecycle) {
          _wasPausedForLifecycle = true;
          cubit.add(const AdminChatPause());
        }
        break;
      case AppLifecycleState.resumed:
        if (_wasPausedForLifecycle) {
          _resumeDebounce?.cancel();
          _resumeDebounce = Timer(const Duration(milliseconds: 400), () {
            if (!mounted) return;
            _wasPausedForLifecycle = false;
            cubit.add(const AdminChatResume());
          });
        }
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  void didPushNext() {
    if (!_allowLifecyclePause) return;
    if (!_wasPausedForLifecycle && !_wasPausedForRoute) {
      _wasPausedForRoute = true;
      context.read<AdminChatCubit>().add(const AdminChatPause());
    }
  }

  @override
  void didPopNext() {
    if (_wasPausedForRoute && !_wasPausedForLifecycle) {
      _wasPausedForRoute = false;
      _resumeDebounce?.cancel();
      _resumeDebounce = Timer(const Duration(milliseconds: 400), () {
        if (!mounted) return;
        context.read<AdminChatCubit>().add(const AdminChatResume());
      });
    }
  }

  void _connect() {
    if (!mounted) return;
    context.read<AdminChatCubit>().add(
          AdminChatConnect(
            fromUserId: widget.fromUserId,
            toUserId: widget.toUserId,
            apiCode: widget.apiCode,
            type1: widget.type1,
            type2: widget.type2,
            isConnectChat: widget.isConnectChat,
          ),
        );
  }

  void _leaveChat() {
    if (_isLeaving) return;
    _isLeaving = true;
    _cancelScheduledConnect();
    _resumeDebounce?.cancel();
    if (!mounted) return;
    try {
      context.read<AdminChatCubit>().add(const AdminChatDisconnect());
    } catch (_) {}
  }

  @override
  void dispose() {
    _startupGuard?.cancel();
    _leaveChat();
    adminChatRouteObserver.unsubscribe(this);
    _cancelScheduledConnect();
    _resumeDebounce?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 280),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _send() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    context.read<AdminChatCubit>().add(AdminChatSendText(text));
    _textController.clear();
  }

  String get _emptyHintName =>
      widget.useTradologieBranding ? 'Tradologie' : widget.recipientName;

  List<ChatMessage> _messagesFor(AdminChatState state) {
    if (state is AdminChatConnected) return state.messages;
    if (state is AdminChatConnecting) return state.messages;
    if (state is AdminChatDisconnected) return state.messages;
    return const [];
  }

  String? _errorMessageFor(AdminChatState state) {
    if (state is AdminChatError) return state.message;
    if (state is AdminChatDisconnected) {
      return state.reason?.isNotEmpty == true
          ? state.reason
          : 'Connection lost. Please try again.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdminChatCubit, AdminChatState>(
      listenWhen: (prev, curr) {
        if (curr is AdminChatConnected && prev is AdminChatConnecting) {
          return curr.messages.isNotEmpty;
        }
        if (curr is AdminChatConnected && prev is AdminChatConnected) {
          return curr.messages.length > prev.messages.length;
        }
        if (curr is AdminChatError && prev is AdminChatConnected) {
          return true;
        }
        return false;
      },
      listener: (context, state) {
        if (state is AdminChatConnected) {
          _scrollToBottom();
        }
        if (state is AdminChatError) {
          CommonToast.error(state.message);
        }
      },
      builder: (context, state) {
        final isInitialLoad =
            state is AdminChatInitial ||
            (state is AdminChatConnecting && state.messages.isEmpty);
        final isReconnecting =
            state is AdminChatConnecting && state.messages.isNotEmpty;
        final isConnected = state is AdminChatConnected;
        final isFailed =
            state is AdminChatDisconnected || state is AdminChatError;
        final messages = _messagesFor(state);
        final errorMessage = _errorMessageFor(state);
        final isSending =
            state is AdminChatConnected && state.isSending;
        final canSend = isConnected && !isSending;

        return PopScope(
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) {
              _leaveChat();
            }
          },
          child: Container(
            color: const Color(0xFFF0F2F5),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      if (messages.isNotEmpty)
                        ListView.builder(
                          controller: _scrollController,
                          padding:
                              const EdgeInsets.fromLTRB(12, 12, 12, 8),
                          itemCount: messages.length,
                          itemBuilder: (_, i) => AdminChatMessageBubble(
                            message: messages[i],
                            useTradologieBranding:
                                widget.useTradologieBranding,
                            peerImageBase64: widget.peerImageBase64,
                            peerDisplayName: widget.recipientName,
                          ),
                        ),
                      if (isInitialLoad || isReconnecting)
                        ColoredBox(
                          color: isReconnecting
                              ? const Color(0xFFF0F2F5).withValues(alpha: 0.6)
                              : Colors.transparent,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      if (isFailed)
                        _ConnectionFailureView(
                          message: errorMessage ?? 'Something went wrong.',
                          onRetry: _scheduleConnect,
                        ),
                      if (isConnected && messages.isEmpty)
                        _EmptyChatState(peerName: _emptyHintName),
                    ],
                  ),
                ),
                if (isConnected)
                  _ChatInputBar(
                    controller: _textController,
                    enabled: canSend,
                    isSending: isSending,
                    onSend: _send,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ConnectionFailureView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ConnectionFailureView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F2F5).withValues(alpha: 0.92),
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 48,
            color: Colors.red.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Unable to connect',
            style: TextStyleConstants.semiBold(
              context,
              fontSize: 17,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyleConstants.regular(
              context,
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 20),
            label: const Text('Reconnect'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  final String peerName;

  const _EmptyChatState({required this.peerName});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline_rounded,
              size: 56,
              color: AppColors.primary.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 16),
            Text(
              'Start the conversation',
              style: TextStyleConstants.semiBold(
                context,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Send a message to $peerName',
              textAlign: TextAlign.center,
              style: TextStyleConstants.regular(
                context,
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatInputBar extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final bool isSending;
  final VoidCallback onSend;

  const _ChatInputBar({
    required this.controller,
    required this.enabled,
    required this.isSending,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 8,
      shadowColor: Colors.black26,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: enabled,
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: enabled ? (_) => onSend() : null,
                  style: TextStyleConstants.regular(context, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Type a message…',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF0F2F5),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: enabled ? AppColors.primary : Colors.grey.shade400,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: enabled ? onSend : null,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: isSending
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 22,
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
