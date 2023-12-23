import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

typedef TTimelineCount = List<bool>;

class PlaybackConfigModel {
  bool muted;
  bool autoplay;

  static const timelineCountDefault = 4;
  TTimelineCount timelineCount;
  VideoPostStateModel currentVideoPost;

  PlaybackConfigModel({
    required this.muted,
    required this.autoplay,
    required this.timelineCount,
    required this.currentVideoPost,
  });
}

class VideoPostStateModel {
  VideoPlayerController? videoController;
  AnimationController? animationController;
  bool? paused;

  VideoPostStateModel({
    this.videoController,
    this.animationController,
    this.paused,
  });
}
