import 'package:equatable/equatable.dart';

class NotificationDetail extends Equatable {
  final String? contentText;
  final String? contentTitle;
  final String? endDateTime;
  final String? extType;
  final int? fcmLogId;
  final String? imageUrl;
  final int? notificationId;
  final String? notificationType;
  final int? priority;
  final dynamic source;
  final String? startDateTime;
  final String? updatedDate;
  final String? userType;
  final bool? isRead;

  const NotificationDetail({
    this.contentText,
    this.contentTitle,
    this.endDateTime,
    this.extType,
    this.fcmLogId,
    this.imageUrl,
    this.notificationId,
    this.notificationType,
    this.priority,
    this.source,
    this.startDateTime,
    this.updatedDate,
    this.userType,
    this.isRead,
  });

  /// `IsRead == false` means notification still needs to be read.
  bool get isUnread => isRead != true;

  @override
  List<Object?> get props {
    return [
      contentText,
      contentTitle,
      endDateTime,
      extType,
      fcmLogId,
      imageUrl,
      notificationId,
      notificationType,
      priority,
      source,
      startDateTime,
      updatedDate,
      userType,
      isRead,
    ];
  }
}
