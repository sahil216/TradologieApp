enum MessageType { text, image, pdf, voice, video, file }

enum MessageStatus { sending, sent, delivered, failed }

class ChatMessageModel {
  final String id;
  final String fromUserId;
  final String message;
  final MessageType type;
  final MessageStatus status;
  final DateTime timestamp;

  // Attachment fields
  final String? attachmentUrl;
  final String? localFilePath;
  final String? fileName;
  final int? fileSize;
  final Duration? duration;
  final bool isUploading;
  final double uploadProgress;

  const ChatMessageModel({
    required this.id,
    required this.fromUserId,
    required this.message,
    required this.type,
    this.status = MessageStatus.sent,
    required this.timestamp,
    this.attachmentUrl,
    this.localFilePath,
    this.fileName,
    this.fileSize,
    this.duration,
    this.isUploading = false,
    this.uploadProgress = 0.0,
  });

  bool get isMe => fromUserId == "me";

  String get formattedTime {
    final h = timestamp.hour.toString().padLeft(2, '0');
    final m = timestamp.minute.toString().padLeft(2, '0');
    return "$h:$m";
  }

  String get formattedFileSize {
    if (fileSize == null) return '';
    if (fileSize! < 1024) return '${fileSize}B';
    if (fileSize! < 1024 * 1024)
      return '${(fileSize! / 1024).toStringAsFixed(1)}KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String get formattedDuration {
    if (duration == null) return '';
    final m = duration!.inMinutes.toString().padLeft(2, '0');
    final s = (duration!.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  ChatMessageModel copyWith({
    String? id,
    String? fromUserId,
    String? message,
    MessageType? type,
    MessageStatus? status,
    DateTime? timestamp,
    String? attachmentUrl,
    String? localFilePath,
    String? fileName,
    int? fileSize,
    Duration? duration,
    bool? isUploading,
    double? uploadProgress,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      fromUserId: fromUserId ?? this.fromUserId,
      message: message ?? this.message,
      type: type ?? this.type,
      status: status ?? this.status,
      timestamp: timestamp ?? this.timestamp,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      localFilePath: localFilePath ?? this.localFilePath,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      duration: duration ?? this.duration,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
    );
  }
}
