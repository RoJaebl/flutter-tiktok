import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
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

class _VideoPostState extends State<VideoPost>
    with SingleTickerProviderStateMixin {
  final VideoPlayerController _videoPlayercontroller =
      VideoPlayerController.asset("assets/videos/sample_video.mp4");

  bool _isPaused = false;

  final Duration _animationDuration = const Duration(milliseconds: 200);
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

  /// Player를 초기화 및 이벤트 등록
  void _initVideoPlayer() async {
    await _videoPlayercontroller.initialize();
    _videoPlayercontroller.addListener(
      _onVideoChange,
    );
    setState(() {});
  }

  /// AnimateController를 초기화 및 이벤트 등록
  void _initAnimateController() {
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.5,
      duration: _animationDuration,
    );
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
    _initAnimateController();
  }

  @override
  void dispose() {
    _videoPlayercontroller.dispose();
    super.dispose();
  }

  /// 화면을 완전히 체우면 비디오 재생
  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    if (visibilityInfo.visibleFraction == 1 &&
        !_videoPlayercontroller.value.isPlaying) {
      _videoPlayercontroller.play();
    }
  }

  void _onTobblePause() {
    if (_videoPlayercontroller.value.isPlaying) {
      _videoPlayercontroller.pause();
      _animationController.reverse();
    } else {
      _videoPlayercontroller.play();
      _animationController.forward();
    }
    setState(() {
      _isPaused = !_isPaused;
    });
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
            onTap: _onTobblePause,
          )),
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
        ],
      ),
    );
  }
}
