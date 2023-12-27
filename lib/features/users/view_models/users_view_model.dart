import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/reops/user_repo.dart';

class UsersViewModel extends AsyncNotifier<UserProfileModel> {
  late final UserRepository _usersRepo;
  late final AuthenticationRepository _authRepo;

  @override
  FutureOr<UserProfileModel> build() async {
    _usersRepo = ref.read(userRepo);
    _authRepo = ref.read(authRepo);

    if (_authRepo.isLoggedIn) {
      final profile = await _usersRepo.findProfile(_authRepo.user!.uid);
      if (profile != null) {
        return UserProfileModel.fromJson(profile);
      }
    }
    return UserProfileModel.empty();
  }

  Future<void> createProfile(
      UserCredential credential, Map<dynamic, dynamic> userForm) async {
    if (credential.user == null) throw Exception("Account not created");

    state = const AsyncValue.loading();
    final profile = UserProfileModel(
      hasAvatar: false,
      bio: "undefined",
      link: "undefined",
      uid: credential.user!.uid,
      name: credential.user!.displayName ?? userForm["name"] ?? "Anon",
      email: credential.user!.email ?? "anon@anon.com",
      birthday: userForm["birthday"] ?? "undefined",
      avatarURL: "",
    );
    await _usersRepo.createProfile(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> onAvatarUpload() async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(hasAvatar: true));
    await _usersRepo.updateUser(state.value!.uid, {"hasAvatar": true});
  }

  Future<void> onAvatarDownload(String url) async {
    if (state.value == null) return;
    state = AsyncValue.data(state.value!.copyWith(avatarURL: url));
    await _usersRepo.updateUser(state.value!.uid, {"avatarURL": url});
  }
}

final usersProvider = AsyncNotifierProvider<UsersViewModel, UserProfileModel>(
  UsersViewModel.new,
);
