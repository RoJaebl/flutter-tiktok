import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/repository/messages_repo.dart';
import 'package:tiktok_clone/features/inbox/view_model/chat_room_view_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class MessageViewModel extends FamilyAsyncNotifier<void, String> {
  late final MessagesRepo _repo;
  late final String _chatId;

  @override
  FutureOr<void> build(String arg) {
    _repo = ref.read(messageRepo);
    _chatId = arg;
  }

  Future<void> sendMessage(String text) async {
    final user = ref.read(usersProvider).value!;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final message = MessageModel(
        text: text,
        userId: user.uid,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        textId: "",
        isDeleted: false,
      );

      await _repo.sendMessage(
        message: message,
        chatId: _chatId,
      );
    });
    await ref.read(chatRoomsProvider.notifier).onRefresh();
  }

  Future<void> updateMessage({
    required String textId,
    required bool delete,
  }) async {
    state = await AsyncValue.guard(() async {
      await ref.read(messageRepo).updateMessage(
            chatId: _chatId,
            textId: textId,
            delete: delete,
          );
    });
  }
}

final messagesProvider =
    AsyncNotifierProvider.family<MessageViewModel, void, String>(
  MessageViewModel.new,
);

final chatProvider =
    StreamProvider.autoDispose.family<List<MessageModel>, String>(
  (ref, chatRoomId) {
    final snapshots = FirebaseFirestore.instance
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("texts")
        .orderBy("createdAt")
        .snapshots();

    final streamMessage = snapshots.map((event) {
      final messages = event.docs.map((doc) {
        return MessageModel.fromJson(doc.data());
      }).toList();

      return messages.reversed.toList();
    });
    return streamMessage;
  },
);
