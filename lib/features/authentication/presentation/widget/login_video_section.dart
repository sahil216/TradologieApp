import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:tradologie_app/core/utils/login_video_constants.dart';
import 'package:tradologie_app/features/authentication/domain/entities/login_video_link.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/get_login_video_link_usecase.dart';
import 'package:tradologie_app/features/authentication/domain/usecases/log_video_link_usecase.dart';
import 'package:tradologie_app/features/authentication/presentation/widget/youtube_player.dart';
import 'package:tradologie_app/injection_container.dart';

/// Fetches login video URL from API and shows [YoutubeVideoPage].
class LoginVideoSection extends StatefulWidget {
  final String heading;
  final String linkType;
  final String token;

  const LoginVideoSection({
    super.key,
    required this.heading,
    required this.linkType,
    this.token = LoginVideoConstants.apiToken,
  });

  @override
  State<LoginVideoSection> createState() => _LoginVideoSectionState();
}

class _LoginVideoSectionState extends State<LoginVideoSection> {
  LoginVideoLink? _videoLink;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadVideoLink();
  }

  Future<void> _loadVideoLink() async {
    final result = await sl<GetLoginVideoLinkUsecase>()(
      GetLoginVideoLinkParams(
        token: widget.token,
        linkType: widget.linkType,
      ),
    );

    if (!mounted) return;

    result.fold(
      (_) => setState(() {
        _loading = false;
        _videoLink = null;
      }),
      (link) => setState(() {
        _loading = false;
        _videoLink = link;
      }),
    );
  }

  Future<void> _onFirstPlay() async {
    final link = _videoLink;
    if (link == null || link.videoLinkId <= 0) return;

    await sl<LogVideoLinkUsecase>()(
      LogVideoLinkParams(
        token: widget.token,
        linkTypeId: link.videoLinkId.toString(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.primary,
            ),
          ),
        ),
      );
    }

    final link = _videoLink;
    if (link == null || link.linkUrl.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return YoutubeVideoPage(
      heading: widget.heading,
      videoUrl: link.linkUrl,
      onFirstPlay: _onFirstPlay,
    );
  }
}
