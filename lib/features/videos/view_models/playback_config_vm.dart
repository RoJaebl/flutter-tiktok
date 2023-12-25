import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends Notifier<PlaybackConfigModel> {
  final PlaybackConfigRepository _repository;

  PlaybackConfigViewModel(this._repository);

  void setMuted(bool value) {
    _repository.setMuted(value);
    state = state..muted = value;
  }

  void setAutoplay(bool value) {
    _repository.setAutoplay(value);
    state = state..autoplay = value;
  }

  void addAllTimelineCount(int count) {
    state = state
      ..timelineCount.addAll(
        TTimelineCount.filled(
          count,
          state.muted,
        ),
      );
  }

  void setTimelineCount(int index, bool value) {
    state = state..timelineCount[index] = value;
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
    );
  }
}

final playbackConfigProvider =
    NotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  () => throw UnimplementedError(),
);
