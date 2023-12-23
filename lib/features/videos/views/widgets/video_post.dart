import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/common/shared/slide_route.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> with TickerProviderStateMixin {
  final VideoPlayerController _videoPlayercontroller =
      VideoPlayerController.asset("assets/videos/sample_video.mp4");

  late bool _isMute;
  late bool _autoplay;
  late bool _isPaused;
  final double _volume = 1.0;

  final Duration _animationDuration = const Duration(milliseconds: 200);

  /// AnimateController를 초기화 및 이벤트 등록
  late final AnimationController _animationController;

  /// Player가 초기화 되고 영상을 마치면 다음 페이지 콜백
  void _onVideoChange() {
    if (_videoPlayercontroller.value.isInitialized) {
      if (_videoPlayercontroller.value.duration ==
          _videoPlayercontroller.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: _autoplay ? 1.5 : 1.0,
      duration: _animationDuration,
    );
    context.read<PlaybackConfigViewModel>().setCurrentVideoPost(
          (state) => state.animationController = _animationController,
        );
    context
        .read<PlaybackConfigViewModel>()
        .currentAnimationController!
        .addListener(() {
      setState(() {});
    });
  }

  /// Player를 초기화 및 이벤트 등록
  void _initVideoPlayer() async {
    _isMute =
        context.read<PlaybackConfigViewModel>().timelineCount[widget.index];
    _autoplay = context.read<PlaybackConfigViewModel>().autoplay;
    _isPaused = !_autoplay;
    await _videoPlayercontroller.initialize();
    await _videoPlayercontroller.setLooping(true);
    _isMute
        ? await _videoPlayercontroller.setVolume(0)
        : await _videoPlayercontroller.setVolume(_volume);
    _autoplay
        ? await _videoPlayercontroller.play()
        : await _videoPlayercontroller.pause();
    kIsWeb ? await _videoPlayercontroller.setVolume(0) : null;

    context.read<PlaybackConfigViewModel>().setCurrentVideoPost((state) {
      state.videoController = _videoPlayercontroller;
      state.paused = _isPaused;
    });
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _initAnimation();
  }

  @override
  void dispose() {
    _videoPlayercontroller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  /// 화면을 완전히 체우면 비디오 재생
  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    if (!mounted) return;
    visibilityInfo.visibleFraction == 1 && !_isPaused
        ? _videoPlayercontroller.play()
        : _videoPlayercontroller.pause();
  }

  void _onTogglePause() async {
    _isPaused = !context.read<PlaybackConfigViewModel>().currentPaused!;
    context.read<PlaybackConfigViewModel>().setCurrentVideoPost(
          (state) => state.paused = _isPaused,
        );
    _isPaused ? _animationController.reverse() : _animationController.forward();
    _isPaused
        ? await _videoPlayercontroller.pause()
        : await _videoPlayercontroller.play();
    setState(() {});
  }

  void _onCommentTap(BuildContext context) async {
    _videoPlayercontroller.value.isPlaying ? _onTogglePause() : null;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const VideoComments(),
    );
    _onTogglePause();
  }

  void _onToggleMute() async {
    _isMute = !_isMute;
    context
        .read<PlaybackConfigViewModel>()
        .setTimelineCount(widget.index, _isMute);
    _isMute
        ? await _videoPlayercontroller.setVolume(0)
        : await _videoPlayercontroller.setVolume(_volume);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("${widget.index}"),
      onVisibilityChanged: _onVisibilityChanged,
      child: Stack(
        children: [
          Positioned.fill(
            child: _videoPlayercontroller.value.isInitialized
                ? VideoPlayer(_videoPlayercontroller)
                : Container(
                    color: Colors.black,
                  ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTap: _onTogglePause,
              onDoubleTap: _onToggleMute,
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, child) => Transform.scale(
                    scale: _animationController.value,
                    child: child,
                  ),
                  child: AnimatedOpacity(
                    duration: _animationDuration,
                    opacity: context
                                .watch<PlaybackConfigViewModel>()
                                .currentPaused ??
                            _isPaused
                        ? 0.8
                        : 0,
                    child: const FaIcon(
                      FontAwesomeIcons.play,
                      color: Colors.white,
                      size: Sizes.size52,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "@헌남",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Gaps.v10,
                Text(
                  "This is my house is suoth korea!!!",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            top: 40,
            child: IconButton(
              icon: FaIcon(
                _isMute
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: _onToggleMute,
              // onPressed: context.read<VideoConfig>().toggleIsMuted,
            ),
          ),
          Positioned(
            bottom: 20,
            right: 10,
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  foregroundImage: NetworkImage(avatarUri),
                  child: Text("헌남"),
                ),
                Gaps.v24,
                VideoButton(
                  icon: FontAwesomeIcons.solidHeart,
                  text: S.of(context).likeCount(87491),
                ),
                Gaps.v24,
                GestureDetector(
                  onTap: () => _onCommentTap(context),
                  child: VideoButton(
                    icon: FontAwesomeIcons.solidComment,
                    text: S.of(context).commentCount(13243),
                  ),
                ),
                Gaps.v24,
                const VideoButton(
                  icon: FontAwesomeIcons.share,
                  text: "Share",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
