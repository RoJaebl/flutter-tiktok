import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/common/shared/slide_route.dart';

class ChatDetailScreen extends StatefulWidget {
  const ChatDetailScreen({super.key});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() => setState(() {}));
  }

  void _onSendTap() {
    _textEditingController.text.isNotEmpty
        ? _textEditingController.clear()
        : null;
  }

  void _onUnFocusTap() => FocusScope.of(context).unfocus();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: _onUnFocusTap,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            horizontalTitleGap: Sizes.size8,
            leading: Stack(
              children: [
                const CircleAvatar(
                  radius: Sizes.size24,
                  foregroundImage: NetworkImage(nikoaAvatarUri),
                  child: Text(
                    "니꼬",
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
            title: const Text(
              "니꼬",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text(
              "Active now",
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
            child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  vertical: Sizes.size20,
                  horizontal: Sizes.size14,
                ),
                itemBuilder: (context, index) {
                  final isMine = index % 2 == 0;

                  return Row(
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
                        child: const Text(
                          "this is a message!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Sizes.size16,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) => Gaps.v10,
                itemCount: 10),
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
                            padding:
                                EdgeInsets.symmetric(horizontal: Sizes.size10),
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
                    onTap: _onSendTap,
                    child: Container(
                      height: Sizes.size40,
                      width: Sizes.size40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _textEditingController.text.isNotEmpty
                            ? Colors.grey.shade800
                            : Colors.grey.shade400,
                      ),
                      child: const Center(
                        child: FaIcon(
                          FontAwesomeIcons.solidPaperPlane,
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
