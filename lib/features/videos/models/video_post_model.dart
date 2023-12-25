import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPostModel {
  VideoPlayerController? videoController;
  AnimationController? animationController;
  bool paused;

  VideoPostModel({
    this.videoController,
    this.animationController,
    required this.paused,
  });
}
