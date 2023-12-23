import 'package:flutter/material.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';
import 'package:video_player/video_player.dart';

class PlaybackConfigViewModel extends ChangeNotifier {
  final PlaybackConfigRepository _repository;

  late final PlaybackConfigModel _model = PlaybackConfigModel(
    muted: _repository.isMuted(),
    autoplay: _repository.isAutoplay(),
    timelineCount: TTimelineCount.filled(
      PlaybackConfigModel.timelineCountDefault,
      _repository.isMuted(),
      growable: true,
    ),
    currentVideoPost: VideoPostStateModel(),
  );

  PlaybackConfigViewModel(this._repository);

  bool get muted => _model.muted;
  bool get autoplay => _model.autoplay;

  int get timelineCountLen => _model.timelineCount.length;
  TTimelineCount get timelineCount => _model.timelineCount;

  VideoPlayerController? get currentVideoController =>
      _model.currentVideoPost.videoController;
  AnimationController? get currentAnimationController =>
      _model.currentVideoPost.animationController;
  bool? get currentPaused => _model.currentVideoPost.paused;

  void setMuted(bool value) {
    _repository.setMuted(value);
    _model.muted = value;
    notifyListeners();
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    _model.autoplay = value;
    notifyListeners();
  }

  void addAllTimelineCount(int count) {
    _model.timelineCount.addAll(
      TTimelineCount.filled(
        count,
        _model.muted,
      ),
    );
  }

  void setTimelineCount(int index, bool muted) {
    _model.timelineCount[index] = muted;
  }

  void setCurrentVideoPost(void Function(VideoPostStateModel state) setState) {
    setState(_model.currentVideoPost);
  }
}
