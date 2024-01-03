import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:video_player/video_player.dart';

class VideoPostModel {
  VideoPlayerController? videoController;
  AnimationController? animationController;
  bool? paused;
  bool isLike;
  VideoModel? video;

  VideoPostModel({
    this.videoController,
    this.animationController,
    this.paused,
    required this.isLike,
    this.video,
  });

  VideoPostModel copyWith({
    VideoPlayerController? videoController,
    AnimationController? animationController,
    bool? paused,
    bool? isLike,
    VideoModel? video,
  }) {
    return VideoPostModel(
      videoController: videoController ?? this.videoController,
      animationController: animationController ?? this.animationController,
      paused: paused ?? this.paused,
      isLike: isLike ?? this.isLike,
      video: video ?? this.video,
    );
  }
}
