import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/features/admin/presentation/widgets/admin_peer_avatar.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';
import 'package:tradologie_app/features/socket/presentation/screen/message_bubble.dart';

/// Message row with peer avatar on incoming messages (admin chat).
class AdminChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool useTradologieBranding;
  final String? peerImageBase64;
  final String peerDisplayName;

  const AdminChatMessageBubble({
    super.key,
    required this.message,
    this.useTradologieBranding = false,
    this.peerImageBase64,
    this.peerDisplayName = '',
  });

  @override
  Widget build(BuildContext context) {
    if (message.isMe) {
      final isTextOnly =
          !message.isImage && !message.isPdf && !message.isAudio;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Align(
          alignment: Alignment.centerRight,
          child: isTextOnly
              ? _SentBubble(message: message)
              : MessageBubble(message: message),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AdminPeerAvatar(
            radius: 16,
            useTradologieBranding: useTradologieBranding,
            imageBase64: peerImageBase64,
            fallbackInitial: peerDisplayName,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: MessageBubble(
              message: message,
              hideLeadingAvatar: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SentBubble extends StatelessWidget {
  final ChatMessage message;

  const _SentBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.72,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(4),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.formattedTime,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 11,
                    ),
                  ),
                  if (message.isUploading) ...[
                    const SizedBox(width: 6),
                    const SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.white70,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(width: 4),
                    Icon(
                      Icons.done_all,
                      size: 14,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
