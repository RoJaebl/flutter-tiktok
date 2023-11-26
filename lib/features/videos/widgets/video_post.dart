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

class _VideoPostState extends State<VideoPost> {
  final VideoPlayerController _videoPlayercontroller =
      VideoPlayerController.asset("assets/videos/sample_video.mp4");

  void _onVideoChange() {
    if (_videoPlayercontroller.value.isInitialized) {
      if (_videoPlayercontroller.value.duration ==
          _videoPlayercontroller.value.position) {
        widget.onVideoFinished();
      }
    }
  }

  void _initVideoPlayer() async {
    await _videoPlayercontroller.initialize();
    _videoPlayercontroller.addListener(
      _onVideoChange,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayercontroller.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo visibilityInfo) {
    if (visibilityInfo.visibleFraction == 1 &&
        !_videoPlayercontroller.value.isPlaying) {
      _videoPlayercontroller.play();
    }
  }

  void _onTobblePause() {
    if (_videoPlayercontroller.value.isPlaying) {
      _videoPlayercontroller.pause();
    } else {
      _videoPlayercontroller.play();
    }
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
          const Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: Opacity(
                  opacity: 0.7,
                  child: FaIcon(
                    FontAwesomeIcons.play,
                    color: Colors.white,
                    size: Sizes.size52,
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
