import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/models/video_model.dart';
import 'package:tiktok_clone/features/videos/models/video_post_model.dart';
import 'package:tiktok_clone/features/videos/repos/videos_repo.dart';

class VideoPostViewModels
    extends FamilyAsyncNotifier<VideoPostModel, VideoModel> {
  late final VideosRepository _repository;
  late final VideoModel _video;
  late final User _user;
  bool _isLike = false;
  int _likes = 0;

  @override
  FutureOr<VideoPostModel> build(VideoModel arg) async {
    _video = arg;
    _repository = ref.read(videosRepo);
    _user = ref.read(authRepo).user!;

    _isLike = await _repository.isLikeVideo(
      videoId: _video.id,
      userId: _user.uid,
    );
    _likes = _video.likes;

    return VideoPostModel(
      video: _video,
      isLike: _isLike,
    );
  }

  Future<void> likeVideo() async {
    _isLike = await _repository.likeVideo(
      videoId: _video.id,
      userId: _user.uid,
    );
    _likes = _likes + (_isLike ? 1 : -1);
    final newVideo = _video.copyWith(
      likes: _likes,
    );
    state = AsyncValue.data(
      state.value!.copyWith(
        isLike: _isLike,
        video: newVideo,
      ),
    );
  }
}

final videoPostsProvider = AsyncNotifierProvider.family<VideoPostViewModels,
    VideoPostModel, VideoModel>(
  VideoPostViewModels.new,
);
