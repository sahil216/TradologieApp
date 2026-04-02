import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tradologie_app/features/socket/presentation/chat_bloc.dart';
import 'package:tradologie_app/features/socket/presentation/chat_event.dart';
import 'package:tradologie_app/features/socket/presentation/cubit/attachement_cubit.dart';

class ChatInputBar extends StatefulWidget {
  final String toUserId;
  final bool enabled;
  final bool isRecording;
  final Duration? recordingDuration;

  const ChatInputBar({
    super.key,
    required this.toUserId,
    required this.enabled,
    this.isRecording = false,
    this.recordingDuration,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;
  late AnimationController _attachAnimCtrl;
  late Animation<double> _attachAnim;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);

      // Typing indicator
      if (has) {
        // context.read<ChatBloc>().add(ChatTypingEvent(widget.toUserId));
      }
    });

    _attachAnimCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _attachAnim = CurvedAnimation(
      parent: _attachAnimCtrl,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _attachAnimCtrl.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<ChatBloc>().add(ChatSendMessageEvent(
          toUser: widget.toUserId,
          message: text,
        ));
    _controller.clear();
  }

  void _toggleAttachMenu() {
    final cubit = context.read<AttachmentCubit>();
    if (cubit.state is AttachmentMenuOpen) {
      cubit.closeMenu();
      _attachAnimCtrl.reverse();
    } else {
      cubit.toggleMenu();
      _attachAnimCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRecording) {
      return _RecordingBar(
        duration: widget.recordingDuration ?? Duration.zero,
        toUserId: widget.toUserId,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Attachment Menu
        BlocBuilder<AttachmentCubit, AttachmentState>(
          builder: (context, state) {
            if (state is AttachmentMenuOpen) {
              return _AttachmentMenu(toUserId: widget.toUserId);
            }
            return const SizedBox.shrink();
          },
        ),

        // Input Row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attach button
              _IconBtn(
                icon: Icons.add,
                onTap: widget.enabled ? _toggleAttachMenu : null,
                active: context.watch<AttachmentCubit>().state
                    is AttachmentMenuOpen,
              ),

              const SizedBox(width: 6),

              // Text field
              Expanded(
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: TextField(
                    controller: _controller,
                    enabled: widget.enabled,
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
                    style: const TextStyle(fontSize: 15),
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
              ),

              const SizedBox(width: 6),

              // Send / Mic button
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: _hasText
                    ? _SendButton(
                        key: const ValueKey('send'), onTap: _sendMessage)
                    : _MicButton(
                        key: const ValueKey('mic'),
                        enabled: widget.enabled,
                        toUserId: widget.toUserId,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────── Recording Bar ───────────────
class _RecordingBar extends StatelessWidget {
  final Duration duration;
  final String toUserId;

  const _RecordingBar({required this.duration, required this.toUserId});

  String _fmt(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          // Cancel
          GestureDetector(
            onTap: () =>
                context.read<ChatBloc>().add(const ChatCancelRecordingEvent()),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_outline, color: Colors.red),
            ),
          ),
          const SizedBox(width: 12),

          // Waveform placeholder
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  _fmt(duration),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Recording...",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),

          // Send
          GestureDetector(
            onTap: () =>
                context.read<ChatBloc>().add(ChatStopRecordingEvent(toUserId)),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF1976D2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── Attachment Menu ───────────────
class _AttachmentMenu extends StatelessWidget {
  final String toUserId;

  const _AttachmentMenu({required this.toUserId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _AttachOption(
            icon: Icons.camera_alt,
            label: "Camera",
            color: Colors.orange,
            onTap: () async {
              context.read<AttachmentCubit>().closeMenu();
              await context.read<AttachmentCubit>().pickFromCamera();
            },
          ),
          _AttachOption(
            icon: Icons.photo_library,
            label: "Gallery",
            color: Colors.purple,
            onTap: () async {
              context.read<AttachmentCubit>().closeMenu();
              await context.read<AttachmentCubit>().pickFromGallery();
            },
          ),
          _AttachOption(
            icon: Icons.picture_as_pdf,
            label: "PDF",
            color: Colors.red,
            onTap: () async {
              context.read<AttachmentCubit>().closeMenu();
              await context.read<AttachmentCubit>().pickPdf();
            },
          ),
        ],
      ),
    );
  }
}

class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── Buttons ───────────────
class _SendButton extends StatelessWidget {
  final VoidCallback onTap;

  const _SendButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Color(0xFF1976D2),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.send, color: Colors.white, size: 20),
      ),
    );
  }
}

class _MicButton extends StatelessWidget {
  final bool enabled;
  final String toUserId;

  const _MicButton({
    super.key,
    required this.enabled,
    required this.toUserId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: enabled
          ? (_) => context.read<ChatBloc>().add(const ChatStartRecordingEvent())
          : null,
      onLongPressEnd: enabled
          ? (_) =>
              context.read<ChatBloc>().add(ChatStopRecordingEvent(toUserId))
          : null,
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Hold to record voice message"),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF1976D2) : Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.mic,
          color: enabled ? Colors.white : Colors.grey,
          size: 22,
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool active;

  const _IconBtn({
    required this.icon,
    this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: active
              ? const Color(0xFF1976D2).withOpacity(0.1)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: active ? const Color(0xFF1976D2) : Colors.grey.shade600,
          size: 24,
        ),
      ),
    );
  }
}
