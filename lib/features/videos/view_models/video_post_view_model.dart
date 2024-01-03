import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_post_model.dart';
import 'package:video_player/video_player.dart';

class VideoPostViewModel extends Notifier<VideoPostModel> {
  void setVideoController(VideoPlayerController controller) {
    state = state..videoController = controller;
  }

  void setAnimationController(AnimationController controller) {
    state = state..animationController = controller;
  }

  void setPaused(bool value) {
    state = state..paused = value;
  }

  @override
  VideoPostModel build() {
    return VideoPostModel(
      isLike: false,
    );
  }
}

final videoPostProvider = NotifierProvider<VideoPostViewModel, VideoPostModel>(
    VideoPostViewModel.new);
