import 'package:tradologie_app/features/authentication/domain/entities/login_video_link.dart';

class LoginVideoLinkModel extends LoginVideoLink {
  const LoginVideoLinkModel({
    required super.videoLinkId,
    required super.linkUrl,
  });

  factory LoginVideoLinkModel.fromJson(Map<String, dynamic> json) {
    return LoginVideoLinkModel(
      videoLinkId: int.tryParse(json['VideoLinkID']?.toString() ?? '') ?? 0,
      linkUrl: json['LinkURL']?.toString() ?? '',
    );
  }
}
