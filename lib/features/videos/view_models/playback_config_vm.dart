import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    _repository.setMuted(value);
    state = PlaybackConfigModel(
      muted: value,
      autoplay: state.autoplay,
      timelineCount: state.timelineCount,
      currentVideoPost: state.currentVideoPost,
    );
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: value,
      timelineCount: state.timelineCount,
      currentVideoPost: state.currentVideoPost,
    );
  }

  void addAllTimelineCount(int count) {
    var newTimelineCount = state.timelineCount;
    newTimelineCount.addAll(
      TTimelineCount.filled(
        count,
        state.muted,
      ),
    );
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: state.autoplay,
      timelineCount: newTimelineCount,
      currentVideoPost: state.currentVideoPost,
    );
  }

  void setTimelineCount(int index, bool muted) {
    var modifyTimelineCount = state.timelineCount;
    modifyTimelineCount[index] = muted;
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: state.autoplay,
      timelineCount: modifyTimelineCount,
      currentVideoPost: state.currentVideoPost,
    );
  }

  void setCurrentVideoPost(
      VideoPostStateModel Function(VideoPostStateModel state) setState) {
    var newState = setState(state.currentVideoPost);
    state = PlaybackConfigModel(
      muted: state.muted,
      autoplay: state.autoplay,
      timelineCount: state.timelineCount,
      currentVideoPost: newState,
    );
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
