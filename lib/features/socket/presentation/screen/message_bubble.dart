import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tradologie_app/features/socket/data/model/message_model.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFFE0E0E0),
              child: Icon(Icons.person, size: 16, color: Colors.grey),
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF1976D2) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMe ? 18 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 18),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: _buildContent(isMe),
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 4),
            _StatusIcon(status: message.status),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(bool isMe) {
    switch (message.type) {
      case MessageType.text:
        return _TextContent(message: message, isMe: isMe);
      case MessageType.image:
        return _ImageContent(message: message, isMe: isMe);
      case MessageType.pdf:
        return _PdfContent(message: message, isMe: isMe);
      case MessageType.voice:
        return _VoiceContent(message: message, isMe: isMe);
      case MessageType.video:
      case MessageType.file:
        return _FileContent(message: message, isMe: isMe);
    }
  }
}

// ─────────────── Text ───────────────
class _TextContent extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;

  const _TextContent({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message.message,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            message.formattedTime,
            style: TextStyle(
              color:
                  isMe ? Colors.white.withOpacity(0.65) : Colors.grey.shade500,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── Image ───────────────
class _ImageContent extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;

  const _ImageContent({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: const Radius.circular(18),
        topRight: const Radius.circular(18),
        bottomLeft: Radius.circular(isMe ? 18 : 4),
        bottomRight: Radius.circular(isMe ? 4 : 18),
      ),
      child: Stack(
        children: [
          // Image
          ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: 160,
              minHeight: 120,
              maxWidth: 280,
              maxHeight: 280,
            ),
            child: _buildImage(),
          ),
          // Upload overlay
          if (message.isUploading)
            Positioned.fill(
              child: Container(
                color: Colors.black38,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                      const SizedBox(height: 6),
                      Text(
                        "${(message.uploadProgress * 100).toInt()}%",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Time stamp
          Positioned(
            bottom: 6,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message.formattedTime,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (message.localFilePath != null) {
      return Image.file(
        File(message.localFilePath!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    if (message.attachmentUrl != null) {
      return Image.network(
        message.attachmentUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        width: 200,
        height: 160,
        color: Colors.grey.shade200,
        child: const Icon(Icons.image, size: 48, color: Colors.grey),
      );
}

// ─────────────── PDF ───────────────
class _PdfContent extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;

  const _PdfContent({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    "PDF",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.fileName ?? message.message,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    if (message.formattedFileSize.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        message.formattedFileSize,
                        style: TextStyle(
                          color: isMe
                              ? Colors.white.withOpacity(0.7)
                              : Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (message.isUploading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                Icon(
                  Icons.download,
                  color: isMe ? Colors.white70 : Colors.grey,
                  size: 20,
                ),
            ],
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              message.formattedTime,
              style: TextStyle(
                color: isMe
                    ? Colors.white.withOpacity(0.65)
                    : Colors.grey.shade500,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────── Voice ───────────────
class _VoiceContent extends StatefulWidget {
  final ChatMessageModel message;
  final bool isMe;

  const _VoiceContent({required this.message, required this.isMe});

  @override
  State<_VoiceContent> createState() => _VoiceContentState();
}

class _VoiceContentState extends State<_VoiceContent> {
  bool _isPlaying = false;
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    final isMe = widget.isMe;
    final message = widget.message;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => setState(() => _isPlaying = !_isPlaying),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isMe
                        ? Colors.white.withOpacity(0.2)
                        : Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: isMe ? Colors.white : Colors.blue,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Waveform visualization
                    _WaveformBar(
                      progress: _progress,
                      isMe: isMe,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      message.formattedDuration,
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            isMe ? Colors.white.withOpacity(0.7) : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              if (message.isUploading)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isMe ? Colors.white70 : Colors.blue,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              message.formattedTime,
              style: TextStyle(
                color: isMe
                    ? Colors.white.withOpacity(0.65)
                    : Colors.grey.shade500,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WaveformBar extends StatelessWidget {
  final double progress;
  final bool isMe;

  const _WaveformBar({required this.progress, required this.isMe});

  @override
  Widget build(BuildContext context) {
    // Simulated waveform heights
    const bars = [
      0.4,
      0.7,
      0.5,
      1.0,
      0.6,
      0.8,
      0.4,
      0.9,
      0.5,
      0.7,
      0.3,
      0.6,
      0.8,
      0.4,
      0.7,
      0.5,
      0.9,
      0.6,
      0.4,
      0.8
    ];
    return SizedBox(
      height: 22,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(bars.length, (i) {
          final filled = i / bars.length <= progress;
          return Container(
            width: 3,
            height: 22 * bars[i],
            margin: const EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: filled
                  ? (isMe ? Colors.white : Colors.blue)
                  : (isMe
                      ? Colors.white.withOpacity(0.35)
                      : Colors.blue.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }
}

// ─────────────── Generic File ───────────────
class _FileContent extends StatelessWidget {
  final ChatMessageModel message;
  final bool isMe;

  const _FileContent({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.insert_drive_file,
            color: isMe ? Colors.white70 : Colors.blue,
            size: 36,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.fileName ?? "File",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  message.formattedTime,
                  style: TextStyle(
                    color: isMe
                        ? Colors.white.withOpacity(0.65)
                        : Colors.grey.shade500,
                    fontSize: 11,
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

// ─────────────── Status Icon ───────────────
class _StatusIcon extends StatelessWidget {
  final MessageStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case MessageStatus.sending:
        return const SizedBox(
          width: 12,
          height: 12,
          child:
              CircularProgressIndicator(strokeWidth: 1.5, color: Colors.grey),
        );
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 14, color: Colors.grey);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: Colors.blue);
      case MessageStatus.failed:
        return const Icon(Icons.error_outline, size: 14, color: Colors.red);
    }
  }
}
