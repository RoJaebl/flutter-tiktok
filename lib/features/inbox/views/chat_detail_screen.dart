import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/inbox/models/chat_room_model.dart';
import 'package:tiktok_clone/features/inbox/models/message.dart';
import 'package:tiktok_clone/features/inbox/view_model/messages_view_model.dart';
import 'package:tiktok_clone/features/inbox/views/chats_screen.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';

class ChatDetailScreenExtra {
  final ChatModel chat;
  final UserProfileModel otherUser;

  ChatDetailScreenExtra({
    required this.chat,
    required this.otherUser,
  });
}

class ChatDetailScreen extends ConsumerStatefulWidget {
  static const String routeName = "chatDetail";
  static const String routeURL = ":chatId";

  final String chatId;
  final ChatDetailScreenExtra extra;

  const ChatDetailScreen({
    super.key,
    required this.chatId,
    required this.extra,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() => setState(() {}));
  }

  void _onSendTap() {
    if (_textEditingController.text != "") {
      ref
          .read(messagesProvider(widget.chatId).notifier)
          .sendMessage(_textEditingController.text);
      _textEditingController.clear();
    }
  }

  void _onUnFocusTap() => FocusScope.of(context).unfocus();

  void _onBackPressed() => context.goNamed(ChatsScreen.routeName);

  Future<void> _onMessageDeleteLongPressed(
      {required MessageModel message}) async {
    void onDeletePressed() {
      final lastTime =
          DateTime.now().millisecondsSinceEpoch - message.createdAt;
      final limitTime = const Duration(minutes: 2).inMilliseconds;
      if (limitTime < lastTime) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "삭제 제한 시간을 초과 하였습니다.",
            ),
          ),
        );
        Navigator.of(context).pop();
      } else {
        ref.read(messagesProvider(widget.chatId).notifier).updateMessage(
              textId: message.textId,
              delete: true,
            );
      }
    }

    await showDialog(
        context: context,
        builder: (context) {
          final user = ref.read(usersProvider).value!;
          return AlertDialog.adaptive(
            title: Text(
              user.name,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: onDeletePressed,
                    child: const Text(
                      "메시지 삭제",
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(messagesProvider(widget.chatId)).isLoading;
    final otherUser = widget.extra.otherUser;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _onBackPressed,
          icon: const FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: Sizes.size20,
          ),
        ),
        title: GestureDetector(
          onTap: _onUnFocusTap,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: Sizes.size8,
            leading: Stack(
              children: [
                CircleAvatar(
                  radius: Sizes.size24,
                  foregroundImage: NetworkImage(
                    otherUser.avatarURL,
                  ),
                  child: otherUser.hasAvatar
                      ? null
                      : Text(
                          otherUser.name,
                        ),
                ),
                Positioned(
                  left: Sizes.size32,
                  top: Sizes.size32,
                  child: Container(
                    height: Sizes.size20,
                    width: Sizes.size20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      border: Border.all(
                        color: Colors.white,
                        width: Sizes.size4,
                      ),
                    ),
                  ),
                )
              ],
            ),
            title: Text(
              otherUser.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(
                  FontAwesomeIcons.flag,
                  color: Colors.black,
                  size: Sizes.size20,
                ),
                Gaps.h32,
                FaIcon(
                  FontAwesomeIcons.ellipsis,
                  color: Colors.black,
                  size: Sizes.size20,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: _onUnFocusTap,
            child: ref.watch(chatProvider(widget.chatId)).when(
                  data: (data) {
                    if (data.isEmpty) {
                      return const Center(child: Text("대화를 시작하세요!"));
                    }
                    return ListView.separated(
                      reverse: true,
                      padding: EdgeInsets.only(
                        top: Sizes.size20,
                        bottom: MediaQuery.of(context).padding.bottom +
                            Sizes.size96,
                        left: Sizes.size14,
                        right: Sizes.size14,
                      ),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final message = data[index];
                        final isMine = message.userId ==
                            ref.read(usersProvider).value!.uid;
                        final isNotDeleted = !data[index].isDeleted;

                        return GestureDetector(
                          onLongPress: isMine && isNotDeleted
                              ? () => _onMessageDeleteLongPressed(
                                    message: data[index],
                                  )
                              : null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: isMine
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                  Sizes.size14,
                                ),
                                decoration: BoxDecoration(
                                  color: isMine
                                      ? Colors.blue
                                      : Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(
                                      Sizes.size20,
                                    ),
                                    topRight: const Radius.circular(
                                      Sizes.size20,
                                    ),
                                    bottomLeft: Radius.circular(
                                      isMine ? Sizes.size20 : Sizes.size5,
                                    ),
                                    bottomRight: Radius.circular(
                                        !isMine ? Sizes.size20 : Sizes.size5),
                                  ),
                                ),
                                child: Text(
                                  message.isDeleted
                                      ? "[삭제된 메세지]"
                                      : message.text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: Sizes.size16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Gaps.v10,
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
          ),
          Positioned(
            bottom: 0,
            width: MediaQuery.of(context).size.width,
            child: BottomAppBar(
              height: Sizes.size72,
              elevation: 1,
              color: Colors.grey.shade50,
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      child: TextField(
                        autocorrect: false,
                        controller: _textEditingController,
                        expands: true,
                        minLines: null,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(Sizes.size32),
                                topRight: Radius.circular(Sizes.size32),
                                topLeft: Radius.circular(Sizes.size32),
                              ),
                              borderSide: BorderSide.none),
                          hintText: "Send a messages...",
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: Sizes.size12,
                          ),
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: Sizes.size10,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.faceGrin,
                                  size: Sizes.size24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gaps.h14,
                  GestureDetector(
                    onTap: isLoading ? null : _onSendTap,
                    child: Container(
                      height: Sizes.size40,
                      width: Sizes.size40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _textEditingController.text.isNotEmpty
                            ? Colors.grey.shade800
                            : Colors.grey.shade400,
                      ),
                      child: Center(
                        child: FaIcon(
                          isLoading
                              ? FontAwesomeIcons.hourglass
                              : FontAwesomeIcons.solidPaperPlane,
                          color: Colors.white,
                          size: Sizes.size18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
