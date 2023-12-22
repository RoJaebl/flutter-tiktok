import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/video_configuration/video_config.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/common/shared/slide_route.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends StatefulWidget {
  final Function onVideoFinished;
  final int index;

  const VideoPost(
      {super.key, required this.onVideoFinished, required this.index});

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> with TickerProviderStateMixin {
  final VideoPlayerController _videoPlayercontroller =
      VideoPlayerController.asset("assets/videos/sample_video.mp4");

  bool _isPaused = false;
  bool _isMute = false;
  final double _volume = 1.0;

  bool _autoMute = videoConfig.autoMute;

  final Duration _animationDuration = const Duration(milliseconds: 200);

  /// AnimateController를 초기화 및 이벤트 등록
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    lowerBound: 1.0,
    upperBound: 1.5,
    value: 1.5,
    duration: _animationDuration,
  );

  /// Player가 초기화 되고 영상을 마치면 다음 페이지 콜백
  void _onVideoChange() {
    if (_videoPlayercontroller.value.isInitialized) {
      if (_videoPlayercontroller.value.duration ==
          _videoPlayercontroller.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  /// Player를 초기화 및 이벤트 등록
  void _initVideoPlayer() async {
    await _videoPlayercontroller.initialize();
    await _videoPlayercontroller.setLooping(true);
    kIsWeb ? await _videoPlayercontroller.setVolume(0) : null;
    _videoPlayercontroller.addListener(
      _onVideoChange,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();

    videoConfig.addListener(() {
      setState(() {
        _autoMute = videoConfig.autoMute;
      });
    });
  }

  @override
  void dispose() {
    _videoPlayercontroller.dispose();
    super.dispose();
  }

  /// 화면을 완전히 체우면 비디오 재생
  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    if (!mounted) return;
    visibilityInfo.visibleFraction == 1 && !_isPaused
        ? _videoPlayercontroller.play()
        : _videoPlayercontroller.pause();
  }

  void _onTogglePause() => setState(() {
        _videoPlayercontroller.value.isPlaying
            ? _videoPlayercontroller.pause()
            : _videoPlayercontroller.play();
        _videoPlayercontroller.value.isPlaying
            ? _animationController.reverse()
            : _animationController.forward();
        _isPaused = !_isPaused;
      });

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

  void _onToggleMute() => setState(() {
        _isMute
            ? _videoPlayercontroller.setVolume(0)
            : _videoPlayercontroller.setVolume(_volume);
        _isMute = !_isMute;
      });

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
                    opacity: _isPaused ? 0.8 : 0,
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
                _autoMute
                    ? FontAwesomeIcons.volumeOff
                    : FontAwesomeIcons.volumeHigh,
                color: Colors.white,
              ),
              onPressed: videoConfig.toggleAutoMute,
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
