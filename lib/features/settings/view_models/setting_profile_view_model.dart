import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class SettingProfileViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> profileUpload({
    String? bio,
    String? link,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await ref.read(usersProvider.notifier).onUpdateUser(
              bio: bio,
              link: link,
            );
      },
    );
  }

  UserProfileModel getUserModel() {
    return ref.read(usersProvider).value!;
  }
}

final settingProfileProvider =
    AsyncNotifierProvider<SettingProfileViewModel, void>(
  SettingProfileViewModel.new,
);
