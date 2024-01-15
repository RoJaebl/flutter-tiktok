import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';

class MessagesRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required MessageModel message,
    required String chatId,
  }) async {
    final json = message.toJson();
    final query = _db.collection("chat_rooms").doc(chatId);
    await query.collection("texts").add(json).then(
          (value) async => await value.update({
            "textId": value.id,
          }),
        );
    await query.update({
      "messageAt": json["createdAt"],
      "lastText": json["text"],
    });
  }

  Future<void> updateMessage({
    required String chatId,
    required String textId,
    required bool delete,
  }) async {
    if (textId == "") return;
    await _db
        .collection("chat_rooms")
        .doc(chatId)
        .collection("texts")
        .doc(textId)
        .update({"isDeleted": delete});
  }
}

final messageRepo = Provider(
  (ref) => MessagesRepo(),
);
