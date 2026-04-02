class ChatMessage {
  final String user;
  final String message;
  final String? file;
  final String? fileType;
  final String? type;

  // UI-only fields (not sent to server)
  final String? localFilePath;
  final Duration? duration;
  final bool isMe;
  final bool isUploading;
  final DateTime? timestamp;

  ChatMessage({
    required this.user,
    required this.message,
    this.file,
    this.fileType,
    this.type,
    this.localFilePath,
    this.duration,
    bool? isMe,
    this.isUploading = false,
    DateTime? timestamp,
  })  : isMe = isMe ?? user == "me",
        timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      "fromUserId": user,
      "message": message,
      "file": file,
      "fileType": fileType,
      "type": type,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      user: json["fromUserId"] ?? "",
      message: json["message"] ?? "",
      file: json["file"],
      fileType: json["fileType"],
      type: json["type"],
    );
  }

  ChatMessage copyWith({
    String? user,
    String? message,
    String? file,
    String? fileType,
    String? type,
    String? localFilePath,
    Duration? duration,
    bool? isMe,
    bool? isUploading,
    DateTime? timestamp,
  }) {
    return ChatMessage(
      user: user ?? this.user,
      message: message ?? this.message,
      file: file ?? this.file,
      fileType: fileType ?? this.fileType,
      type: type ?? this.type,
      localFilePath: localFilePath ?? this.localFilePath,
      duration: duration ?? this.duration,
      isMe: isMe ?? this.isMe,
      isUploading: isUploading ?? this.isUploading,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  // ── Helpers ────────────────────────────────────────────────
  bool get isImage => fileType == "image";
  bool get isPdf => fileType == "pdf";
  bool get isAudio => fileType == "audio" || fileType == "voice";
  bool get isFile => type == "file";
  bool get isText => type == "text" || (type == null && file == null);

  String get formattedTime {
    final t = timestamp ?? DateTime.now();
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String get formattedDuration {
    if (duration == null) return '';
    final m = duration!.inMinutes.toString().padLeft(2, '0');
    final s = (duration!.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
