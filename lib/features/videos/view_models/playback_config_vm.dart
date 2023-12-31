import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends AsyncNotifier<PlaybackConfigModel> {
  late final PlaybackConfigRepository _playbackRepo;

  int get playbackLength =>
      (state.value as PlaybackConfigModel).timelineCount.length;

  Future<void> setMuted(bool value) async {
    state = const AsyncValue.loading();
    await _playbackRepo.setMuted(value);
    state = AsyncValue.data(state.value!..muted = value);
  }

  Future<void> setAutoplay(bool value) async {
    state = const AsyncValue.loading();
    await _playbackRepo.setAutoplay(value);
    state = AsyncValue.data(state.value!..autoplay = value);
  }

  void addAllTimelineCount(int count) {
    state = const AsyncValue.loading();
    state = AsyncValue.data(
      state.value!
        ..timelineCount.addAll(
          TTimelineCount.filled(
            count,
            state.value!.muted,
          ),
        ),
    );
  }

  void setTimelineCount(int index, bool value) {
    state = AsyncValue.data(
      state.value!..timelineCount[index] = value,
    );
  }

  @override
  FutureOr<PlaybackConfigModel> build() async {
    _playbackRepo = ref.read(playbackRepo);

    return PlaybackConfigModel(
      muted: await _playbackRepo.isMuted(),
      autoplay: await _playbackRepo.isAutoplay(),
      timelineCount: TTimelineCount.filled(
        PlaybackConfigModel.timelineCountDefault,
        await _playbackRepo.isMuted(),
        growable: true,
      ),
    );
  }
}

final playbackConfigProvider =
    AsyncNotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  PlaybackConfigViewModel.new,
);
