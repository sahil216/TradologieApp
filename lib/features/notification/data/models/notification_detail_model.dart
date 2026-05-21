import '../../domain/entities/notification_detail.dart';

class NotificationDetailModel extends NotificationDetail {
  const NotificationDetailModel({
    super.contentText,
    super.contentTitle,
    super.endDateTime,
    super.extType,
    super.fcmLogId,
    super.imageUrl,
    super.notificationId,
    super.notificationType,
    super.priority,
    super.source,
    super.startDateTime,
    super.updatedDate,
    super.userType,
    super.isRead,
  });

  static bool? _parseIsRead(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final normalized = value.toLowerCase();
      if (normalized == 'true' || normalized == '1') return true;
      if (normalized == 'false' || normalized == '0') return false;
    }
    return null;
  }

  factory NotificationDetailModel.fromJson(Map<String, dynamic> json) =>
      NotificationDetailModel(
        contentText: json["ContentText"],
        contentTitle: json["ContentTitle"],
        endDateTime: json["EndDateTime"].toString(),
        extType: json["ExtType"],
        fcmLogId: json["FCMLogID"],
        imageUrl: json["ImageUrl"],
        notificationId: json["NotificationID"],
        notificationType: json["NotificationType"],
        priority: json["Priority"],
        source: json["Source"],
        startDateTime: json["StartDateTime"].toString(),
        updatedDate: json["UpdatedDate"],
        userType: json["UserType"],
        isRead: _parseIsRead(json["IsRead"]),
      );
}
