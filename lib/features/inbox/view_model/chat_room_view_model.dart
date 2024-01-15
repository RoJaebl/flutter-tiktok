import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repository/chat_repo.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class ChatRoomsViewModel extends AsyncNotifier<ChatRoomModel> {
  late final ChatRepo _chatRepo;
  final Set<UserProfileModel> _users = {};
  Set<ChatModel> _chats = {};

  Future<Set<ChatModel>> _fetchChats() async {
    final userId = ref.read(usersProvider).value!.uid;
    final result = await _chatRepo.fetchChats(
      userId: userId,
    );

    final chatList = result.docs.map((doc) async {
      final chat = ChatModel.fromJson(doc.data());
      final userId = ref.read(usersProvider).value!.uid;
      final otherId =
          chat.personIdA == userId ? chat.personIdB : chat.personIdA;

      final user = _users.where((user) => user.uid == otherId).firstOrNull;
      if (user == null) {
        _users.add(await ref
            .read(usersProvider.notifier)
            .findProfile(userId: otherId));
      }
      return chat;
    });

    final chats = (await Future.wait(chatList)).toList();
    chats.sort((chatA, cahtB) {
      return -chatA.messageAt.compareTo(cahtB.messageAt);
    });

    return Set.from(chats);
  }

  @override
  FutureOr<ChatRoomModel> build() async {
    _chatRepo = ref.read(chatRepo);

    _chats = await _fetchChats();
    if (_chats.isEmpty) return ChatRoomModel.empty();

    return ChatRoomModel(
      users: _users,
      chats: _chats,
    );
  }

  Future<void> onRefresh() async {
    _chats = await _fetchChats();

    state = AsyncValue.data(
      state.value!.copyWith(
        chats: _chats,
        users: _users,
      ),
    );
  }

  void differentRefresh({
    required ChatModel chat,
    required List<MessageModel>? messages,
  }) {
    if (messages == null) return;
    if (messages.isNotEmpty && messages.first.text == chat.lastText) return;
    onRefresh();
  }

  // 챗정보를 얻어와서 다른 사용자의 아이디가 state.user에 존제하면 다른 사용자 정보 반환
  UserProfileModel chatOtherUser({
    required ChatModel chat,
  }) {
    final userId = ref.read(usersProvider).value!.uid;
    final otherId = userId != chat.personIdA ? chat.personIdA : chat.personIdB;

    return _users.firstWhere((user) => user.uid == otherId);
  }
}

final chatRoomsProvider =
    AsyncNotifierProvider<ChatRoomsViewModel, ChatRoomModel>(
  ChatRoomsViewModel.new,
);
