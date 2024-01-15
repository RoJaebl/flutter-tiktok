import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';

class ChatRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> fetchUesrs() async {
    return await _db.collection("users").limit(20).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchChats({
    required String userId,
  }) async {
    final query = _db.collection("chat_rooms").where(Filter.or(
          Filter("personIdA", isEqualTo: userId),
          Filter("personIdB", isEqualTo: userId),
        ));
    return query.get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> createChatRoom({
    required String userId,
    required String otherId,
  }) async {
    final query = _db.collection("chat_rooms");
    final now = DateTime.now().millisecondsSinceEpoch;

    final chatId = await query
        .add(
          ChatModel(
            chatId: "",
            createdAt: now,
            lastText: "",
            messageAt: now,
            personIdA: userId,
            personIdB: otherId,
          ).toJson(),
        )
        .then(
          (doc) => doc.id,
        );
    await query.doc(chatId).update(
      {"chatId": chatId},
    );

    return query.doc(chatId).get();
  }
}

final chatRepo = Provider(
  (ref) => ChatRepo(),
);
