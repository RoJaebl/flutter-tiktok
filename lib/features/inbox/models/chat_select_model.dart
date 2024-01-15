import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

class ChatSelectModel {
  final String? chatId;
  final List<UserProfileModel> users;

  ChatSelectModel({
    required this.chatId,
    required this.users,
  });

  ChatSelectModel copyWith({
    String? chatId,
    List<UserProfileModel>? users,
  }) {
    return ChatSelectModel(
      chatId: chatId ?? this.chatId,
      users: users ?? this.users,
    );
  }
}
