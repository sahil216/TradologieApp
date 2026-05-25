import 'package:flutter/material.dart';
import 'package:tradologie_app/core/utils/app_colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

/// Compact embeddable YouTube player for sign-in (no nested [Scaffold]).
class YoutubeVideoPage extends StatefulWidget {
  final String heading;
  final String videoUrl;
  final Future<void> Function()? onFirstPlay;

  const YoutubeVideoPage({
    super.key,
    required this.heading,
    required this.videoUrl,
    this.onFirstPlay,
  });


  @override
  State<YoutubeVideoPage> createState() => _YoutubeVideoPageState();
}

class _YoutubeVideoPageState extends State<YoutubeVideoPage> {
  YoutubePlayerController? _controller;
  bool _ready = false;
  bool _firstPlayHandled = false;

  @override
  void initState() {
    super.initState();


    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId != null && videoId.isNotEmpty) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
        ),
      )..addListener(_listener);
    }
  }



  void _listener() {
    final controller = _controller;
    if (!mounted || controller == null) return;

    if (controller.value.isReady && !_ready) {
      setState(() => _ready = true);
    }

    if (!_firstPlayHandled &&
        controller.value.playerState == PlayerState.playing) {
      _firstPlayHandled = true;
      _onFirstPlay();
    }
  }

  void _onFirstPlay() {
    widget.onFirstPlay?.call();
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _controller;
    if (c == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(
              Icons.play_circle_fill_rounded,
              color: AppColors.red,
              size: 18,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                widget.heading,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.defaultText,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  width: 1,
                ),
                color: Colors.black,
              ),
              // Slightly shorter than 16:9 to save vertical space on sign-in.
              child: AspectRatio(
                aspectRatio: 16 / 10,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    YoutubePlayer(
                      controller: c,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: AppColors.primary,
                      progressColors: ProgressBarColors(
                        playedColor: AppColors.primary,
                        handleColor: AppColors.white,
                        backgroundColor: Colors.white24,
                        bufferedColor: Colors.white38,
                      ),
                    ),
                    if (!_ready)
                      Container(
                        color: Colors.black87,
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
