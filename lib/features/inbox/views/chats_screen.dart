import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:relative_time/relative_time.dart';
import 'package:tiktok_clone/common/views/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/view_model/chat_room_view_model.dart';
import 'package:tiktok_clone/features/inbox/view_model/messages_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/views/widgets/chat_select_widget.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class ChatsScreen extends ConsumerStatefulWidget {
  static const String routeName = "chats";
  static const String routeURL = "/chats";
  const ChatsScreen({super.key});

  @override
  ConsumerState<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends ConsumerState<ChatsScreen> {
  void _onChatSelectPressed() => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ChatsSelect(
                  chats: ref.read(chatRoomsProvider).value!.chats,
                )),
      );

  void _onChatTap({
    required ChatModel chat,
    required UserProfileModel otherUser,
  }) {
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatId": chat.chatId},
      extra: ChatDetailScreenExtra(
        chat: chat,
        otherUser: otherUser,
      ),
    );
  }

  void _onBackPressed() => context.goNamed(
        MainNavigationScreen.routeName,
        params: {
          "tab": "inbox",
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          onPressed: _onBackPressed,
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: Sizes.size20,
          ),
        ),
        title: const Text("Direct messages"),
        actions: [
          IconButton(
            onPressed: _onChatSelectPressed,
            icon: const FaIcon(
              FontAwesomeIcons.plus,
            ),
          ),
        ],
      ),
      body: ref.watch(chatRoomsProvider).when(
            data: (data) {
              return data.chats.isNotEmpty
                  ? ListView.builder(
                      itemCount: data.chats.length,
                      itemBuilder: (context, index) {
                        final chat = [...data.chats][index];
                        final messages =
                            ref.watch(chatProvider(chat.chatId)).value;
                        ref.read(chatRoomsProvider.notifier).differentRefresh(
                              chat: chat,
                              messages: messages,
                            );
                        final otherUser =
                            ref.read(chatRoomsProvider.notifier).chatOtherUser(
                                  chat: chat,
                                );
                        final user = ref.read(usersProvider).value!;

                        return GestureDetector(
                          onTap: () => _onChatTap(
                            chat: chat,
                            otherUser: otherUser,
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 30,
                              foregroundImage:
                                  NetworkImage(otherUser.avatarURL),
                              child: otherUser.hasAvatar
                                  ? null
                                  : Text(
                                      otherUser.name,
                                    ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  otherUser.uid == user.uid
                                      ? "${otherUser.name} (나에게 채팅하기)"
                                      : otherUser.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  RelativeTime(
                                    context,
                                  ).format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      chat.messageAt,
                                    ),
                                  ),
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: Sizes.size12,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              chat.lastText,
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "대화 상태가 아직 없어요",
                      ),
                    );
            },
            error: (error, stackTrace) => Center(
              child: Text(
                error.toString(),
              ),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
    );
  }
}
