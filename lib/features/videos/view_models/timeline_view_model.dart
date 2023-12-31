import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';

class TimelineViewModel extends AsyncNotifier<List<VideoModel>> {
  List<VideoModel> _list = [];
  void uploadVideo() async {
    state = const AsyncValue.loading();
    _list = [
      ..._list,
    ];
    state = AsyncValue.data(_list);
  }

  @override
  FutureOr<List<VideoModel>> build() async {
    return _list;
  }
}

final timelineProvider =
    AsyncNotifierProvider<TimelineViewModel, List<VideoModel>>(
  TimelineViewModel.new,
);
