class ChatMessage {
  final String? user; // fromUserId
  final String message;
  final String? file; // base64 string or file URL
  final String?
      fileType; // MIME or short type: "image/png", "application/pdf", "audio/m4a"
  final String? type; // sender role from BE: "Seller", "Buyer", etc.

  // UI-only fields (never included in toJson)
  final String? localFilePath;
  final Duration? duration;
  final bool isMe;
  final bool isUploading;
  final DateTime? timestamp;

  ChatMessage({
    this.user,
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

  /// Wire format sent to / received from the backend
  Map<String, dynamic> toJson() {
    return {
      "Message": message,
      "File": file,
      "FileType": fileType,
      "Type": type, // role: "Seller" / "Buyer"
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json["message"],
      file: json["file"],
      fileType: json["fileType"],
      type: json["type"], // role string from BE
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

  // ── Attachment helpers — driven by fileType (MIME), not type (role) ────────
  bool get hasAttachment => file != null && file!.isNotEmpty;
  bool get isImage => _mimeStartsWith("image/");
  bool get isPdf => fileType == "application/pdf" || fileType == "pdf";
  bool get isAudio => _mimeStartsWith("audio/");
  bool get isVideo => _mimeStartsWith("video/");
  bool get isText => !hasAttachment;

  bool _mimeStartsWith(String prefix) =>
      fileType != null && fileType!.toLowerCase().startsWith(prefix);

  // ── Role helpers ───────────────────────────────────────────────────────────
  String get senderRole => type ?? "";
  bool get isSeller => type?.toLowerCase() == "seller";
  bool get isBuyer => type?.toLowerCase() == "buyer";

  // ── Display helpers ────────────────────────────────────────────────────────
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

  @override
  String toString() =>
      'ChatMessage(user: $user, role: $type, fileType: $fileType, message: $message)';
}
