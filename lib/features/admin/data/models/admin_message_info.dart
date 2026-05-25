/// Payload for SignalR `SendMessage` → `MessageInfo` (connect.tradologie.com).
class AdminMessageInfo {
  final String message;
  final String? file;
  final String? fileType;

  const AdminMessageInfo({
    required this.message,
    this.file,
    this.fileType,
  });

  Map<String, dynamic> toJson() => {
        'Message': message,
        'message': message,
        'msgContent': message,
        'MsgContent': message,
        if (file != null && file!.isNotEmpty) ...{
          'File': file,
          'file': file,
        },
        if (fileType != null && fileType!.isNotEmpty) ...{
          'FileType': fileType,
          'fileType': fileType,
        },
      };
}
