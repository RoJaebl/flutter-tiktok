import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/repo/user_repo.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class AvatarViewModel extends AsyncNotifier<void> {
  late final UserRepository _userRepo;

  @override
  FutureOr<void> build() {
    _userRepo = ref.read(userRepo);
  }

  Future<void> uploadAvatar(File file) async {
    state = const AsyncValue.loading();
    final fileName = ref.read(authRepo).user!.uid;

    state = await AsyncValue.guard(
      () async {
        await _userRepo.uploadAvatar(file, fileName);
        await ref.read(usersProvider.notifier).onAvatarUpload();
      },
    );
  }

  Future<void> downloadAvatar(String fileName) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(
      () async {
        final avatarURL = await _userRepo.downloadAvatar(fileName);
        await ref.read(usersProvider.notifier).onAvatarDownload(avatarURL);
      },
    );
  }
}

final avatarProvider = AsyncNotifierProvider<AvatarViewModel, void>(
  () => AvatarViewModel(),
);
