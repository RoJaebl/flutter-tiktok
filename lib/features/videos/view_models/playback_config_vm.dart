import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';
import 'package:video_player/video_player.dart';

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  // bool get muted => _model.muted;
  // bool get autoplay => _model.autoplay;

  // int get timelineCountLen => _model.timelineCount.length;
  // TTimelineCount get timelineCount => _model.timelineCount;

  // VideoPlayerController? get currentVideoController =>
  //     _model.currentVideoPost.videoController;
  // AnimationController? get currentAnimationController =>
  //     _model.currentVideoPost.animationController;
  // bool? get currentPaused => _model.currentVideoPost.paused;

  void setMuted(bool value) {
    _repository.setMuted(value);
    state = PlaybackConfigModel(
        muted: value,
        autoplay: state.autoplay,
        timelineCount: state.timelineCount,
        currentVideoPost: state.currentVideoPost);
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(
        muted: state.muted,
        autoplay: value,
        timelineCount: state.timelineCount,
        currentVideoPost: state.currentVideoPost);
  }

  void addAllTimelineCount(int count) {
    state.timelineCount.addAll(
      TTimelineCount.filled(
        count,
        state.muted,
      ),
    );
  }

  void setTimelineCount(int index, bool muted) {
    state.timelineCount[index] = muted;
  }

  void setCurrentVideoPost(void Function(VideoPostStateModel state) setState) {
    setState(state.currentVideoPost);
  }

  @override
  PlaybackConfigModel build() {
    return PlaybackConfigModel(
      muted: _repository.isMuted(),
      autoplay: _repository.isAutoplay(),
      timelineCount: TTimelineCount.filled(
        PlaybackConfigModel.timelineCountDefault,
        _repository.isMuted(),
        growable: true,
      ),
      currentVideoPost: VideoPostStateModel(),
    );
  }
}

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);
