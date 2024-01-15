import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/repository/chat_repo.dart';
import 'package:tiktok_clone/features/inbox/view_model/chat_room_view_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class ChatsSelectViewModel extends AsyncNotifier<List<UserProfileModel>> {
  late final ChatRepo _repo;
  late final List<UserProfileModel> _users;

  Future<List<UserProfileModel>> _fetchUsers() async {
    final result = await _repo.fetchUesrs();
    final users = result.docs.map((doc) {
      return UserProfileModel.fromJson(doc.data());
    });

    return users.toList();
  }

  @override
  FutureOr<List<UserProfileModel>> build() async {
    _repo = ref.read(chatRepo);
    _users = await _fetchUsers();
    return _users;
  }

  Future<ChatModel> createChatRoom({
    required String otherId,
  }) async {
    final userId = ref.read(usersProvider).value!.uid;
    late final ChatModel chat;

    state = await AsyncValue.guard(() async {
      final result = await _repo.createChatRoom(
        userId: userId,
        otherId: otherId,
      );
      chat = ChatModel.fromJson(result.data()!);

      return _users;
    });

    ref.read(chatRoomsProvider.notifier).onRefresh();

    return chat;
  }

  Future<ChatModel?> findChatRoom({
    required Set<ChatModel> chats,
    required String otherId,
  }) async {
    final userId = ref.read(usersProvider).value!.uid;

    final chat = chats
        .where((chat) =>
            (chat.personIdA == userId && chat.personIdB == otherId) ||
            (chat.personIdA == otherId && chat.personIdB == userId))
        .nonNulls;

    return chat.isEmpty ? null : chat.first;
  }
}

final chatsSelectProvider =
    AsyncNotifierProvider<ChatsSelectViewModel, List<UserProfileModel>>(
  ChatsSelectViewModel.new,
);
