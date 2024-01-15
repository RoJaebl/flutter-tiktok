import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatRoomModel {
  final Set<UserProfileModel> users;
  final Set<ChatModel> chats;

  ChatRoomModel({
    required this.users,
    required this.chats,
  });

  ChatRoomModel.empty()
      : users = {},
        chats = {};

  ChatRoomModel copyWith({
    Set<UserProfileModel>? users,
    Set<ChatModel>? chats,
  }) =>
      ChatRoomModel(
        users: users ?? this.users,
        chats: chats ?? this.chats,
      );
}

class ChatModel {
  final String chatId;
  final int createdAt;
  final String lastText;
  final int messageAt;
  final String personIdA;
  final String personIdB;

  ChatModel({
    required this.chatId,
    required this.createdAt,
    required this.lastText,
    required this.messageAt,
    required this.personIdA,
    required this.personIdB,
  });

  ChatModel.fromJson(Map<String, dynamic> json)
      : chatId = json["chatId"],
        createdAt = json["createdAt"],
        lastText = json["lastText"],
        messageAt = json["messageAt"],
        personIdA = json["personIdA"],
        personIdB = json["personIdB"];

  Map<String, dynamic> toJson() {
    return {
      "chatId": chatId,
      "createdAt": createdAt,
      "lastText": lastText,
      "messageAt": messageAt,
      "personIdA": personIdA,
      "personIdB": personIdB,
    };
  }
}
