import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/view_models/video_post_view_model.dart';
import 'package:tiktok_clone/features/videos/view_models/video_post_view_models.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_button.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_comments.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class VideoPost extends ConsumerStatefulWidget {
  final Function onVideoFinished;
  final VideoModel videoData;
  final int index;

  const VideoPost({
    super.key,
    required this.onVideoFinished,
    required this.index,
    required this.videoData,
  });

  @override
  VideoPostState createState() => VideoPostState();
}

class VideoPostState extends ConsumerState<VideoPost>
    with TickerProviderStateMixin {
  final VideoPlayerController _videoPlayercontroller =
      VideoPlayerController.asset("assets/videos/sample_video.mp4");

  late bool _isMute = false;
  late bool _autoplay = false;
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
    // ref
    //     .read(videoPostProvider.notifier)
    //     .setAnimationController(_animationController);
    // ref.read(videoPostProvider).animationController?.addListener(() {
    //   setState(() {});
    // });
  }

  void _onToggleLikeTap() {
    ref.read(videoPostsProvider(widget.videoData).notifier).likeVideo();
  }

  /// Player를 초기화 및 이벤트 등록
  void _initVideoPlayer() async {
    _isMute = ref.read(playbackConfigProvider).value?.muted ?? false;
    _autoplay = ref.read(playbackConfigProvider).value?.autoplay ?? false;
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

    ref
        .read(videoPostProvider.notifier)
        .setVideoController(_videoPlayercontroller);
    ref.read(videoPostProvider.notifier).setPaused(_isPaused);
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
    _isPaused = !ref.read(videoPostProvider).paused!;
    ref.read(videoPostProvider.notifier).setPaused(_isPaused);
    _isPaused = !_isPaused;
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
    _isMute
        ? await _videoPlayercontroller.setVolume(0)
        : await _videoPlayercontroller.setVolume(_volume);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(videoPostsProvider(widget.videoData)).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "Could not load videos: $error",
              style: const TextStyle(
                color: Color.fromARGB(255, 70, 59, 59),
              ),
            ),
          ),
          data: (data) => VisibilityDetector(
            key: Key("${widget.index}"),
            onVisibilityChanged: _onVisibilityChanged,
            child: Stack(
              children: [
                Positioned.fill(
                  child: _videoPlayercontroller.value.isInitialized
                      ? VideoPlayer(_videoPlayercontroller)
                      : Image.network(
                          widget.videoData.thumbnailUrl,
                          fit: BoxFit.cover,
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
                          opacity:
                              ref.watch(videoPostProvider).paused! ? 0.8 : 0,
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
                Positioned(
                  bottom: 20,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "@${widget.videoData.creator}",
                        style: const TextStyle(
                          fontSize: Sizes.size20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.v10,
                      Text(
                        widget.videoData.description,
                        style: const TextStyle(
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
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        foregroundImage: NetworkImage(
                            ref.watch(usersProvider).value?.avatarURL ?? ""),
                        child: Text(
                          widget.videoData.creator,
                        ),
                      ),
                      Gaps.v24,
                      GestureDetector(
                        onTap: _onToggleLikeTap,
                        child: VideoButton(
                          icon: FontAwesomeIcons.solidHeart,
                          color:
                              data.isLike ? Colors.red.shade300 : Colors.white,
                          text: S.of(context).likeCount(
                                data.video!.likes,
                              ),
                        ),
                      ),
                      Gaps.v24,
                      GestureDetector(
                        onTap: () => _onCommentTap(context),
                        child: VideoButton(
                          icon: FontAwesomeIcons.solidComment,
                          color: Colors.white,
                          text: S.of(context).commentCount(
                                widget.videoData.comments,
                              ),
                        ),
                      ),
                      Gaps.v24,
                      const VideoButton(
                        icon: FontAwesomeIcons.share,
                        color: Colors.white,
                        text: "Share",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
