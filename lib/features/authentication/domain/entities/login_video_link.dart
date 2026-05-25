import 'package:equatable/equatable.dart';

class LoginVideoLink extends Equatable {
  final int videoLinkId;
  final String linkUrl;

  const LoginVideoLink({
    required this.videoLinkId,
    required this.linkUrl,
  });

  @override
  List<Object?> get props => [videoLinkId, linkUrl];
}
