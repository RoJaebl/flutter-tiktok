import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/playback_config_model.dart';
import 'package:tiktok_clone/features/videos/repos/playback_config_repo.dart';

class PlaybackConfigViewModel extends AsyncNotifier<PlaybackConfigModel> {
  late final PlaybackConfigRepository _playbackRepo;

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

  @override
  FutureOr<PlaybackConfigModel> build() async {
    _playbackRepo = ref.read(playbackRepo);

    return PlaybackConfigModel(
      muted: await _playbackRepo.isMuted(),
      autoplay: await _playbackRepo.isAutoplay(),
    );
  }
}

final playbackConfigProvider =
    AsyncNotifierProvider<PlaybackConfigViewModel, PlaybackConfigModel>(
  PlaybackConfigViewModel.new,
);
