import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/view_model/chat_select_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chat_detail_screen.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/utils.dart';

class ChatsSelect extends ConsumerWidget {
  final Set<ChatModel> chats;

  const ChatsSelect({
    super.key,
    required this.chats,
  });

  Future<void> _onChatTap(
    BuildContext context,
    WidgetRef ref, {
    required UserProfileModel otherUser,
  }) async {
    ChatModel? chat = await ref
        .read(chatsSelectProvider.notifier)
        .findChatRoom(chats: chats, otherId: otherUser.uid);

    chat ??= await ref.read(chatsSelectProvider.notifier).createChatRoom(
          otherId: otherUser.uid,
        );

    if (!context.mounted) return;
    context.pushNamed(
      ChatDetailScreen.routeName,
      params: {"chatId": chat.chatId},
      extra: ChatDetailScreenExtra(
        chat: chat,
        otherUser: otherUser,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Select User",
        ),
      ),
      body: ref.watch(chatsSelectProvider).when(
            data: (data) {
              return data.isNotEmpty
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: Breakpoints.sm,
                      ),
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final otherUser = data[index];
                          final user = ref.read(usersProvider).value!;
                          return ListTile(
                            minVerticalPadding: Sizes.size20 + Sizes.size2,
                            leading: Container(
                              width: Sizes.size52,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? Colors.grey.shade800
                                    : Colors.white,
                                border: Border.all(
                                  color: isDark
                                      ? Colors.grey.shade900
                                      : Colors.grey.shade400,
                                  width: Sizes.size1,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                foregroundImage: otherUser.hasAvatar
                                    ? NetworkImage(
                                        otherUser.avatarURL,
                                      )
                                    : null,
                                child: otherUser.hasAvatar
                                    ? null
                                    : Text(otherUser.name),
                              ),
                            ),
                            title: Text(
                              otherUser.uid == user.uid
                                  ? "${otherUser.name} (나에게 채팅하기)"
                                  : otherUser.name,
                            ),
                            trailing: IconButton(
                              onPressed: () => _onChatTap(
                                context,
                                ref,
                                otherUser: otherUser,
                              ),
                              icon: const FaIcon(
                                FontAwesomeIcons.paperPlane,
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text(
                        "가입된 사용자가 없습니다.",
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
