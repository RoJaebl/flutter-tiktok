import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';
import 'package:tiktok_clone/features/videos/view_models/timeline_view_model.dart';
import 'package:tiktok_clone/features/videos/views/widgets/video_post.dart';

class VideoTimelineScreen extends ConsumerStatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  VideoTimelineScreenState createState() => VideoTimelineScreenState();
}

class VideoTimelineScreenState extends ConsumerState<VideoTimelineScreen> {
  late int _itemCount = ref.read(playbackConfigProvider).timelineCount.length;
  final PageController _pageController = PageController();
  final Duration _scrollDuration = const Duration(milliseconds: 150);
  final Curve _scrollCurve = Curves.linear;

  void _onPageChanged(int page) {
    _pageController.animateToPage(
      page,
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
    if (page == _itemCount - 1) {
      ref.read(playbackConfigProvider.notifier).addAllTimelineCount(
            PlaybackConfigModel.timelineCountDefault,
          );
      _itemCount = ref.read(playbackConfigProvider).timelineCount.length;
      setState(() {});
    }
  }

  void _onVideoFinished() {
    _pageController.nextPage(
      duration: _scrollDuration,
      curve: _scrollCurve,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onRefres() => Future.delayed(const Duration(seconds: 5));

  @override
  Widget build(BuildContext context) {
    return ref.watch(timelineProvider).when(
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text(
              "Could not load videos: $error",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          data: (vidoes) => RefreshIndicator(
            onRefresh: _onRefres,
            displacement: 0,
            edgeOffset: 34,
            color: Theme.of(context).primaryColor,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: vidoes.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) => VideoPost(
                onVideoFinished: _onVideoFinished,
                index: index,
              ),
            ),
          ),
        );
  }
}
