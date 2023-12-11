import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/utils.dart';

class VideoComments extends StatefulWidget {
  const VideoComments({super.key});

  @override
  State<VideoComments> createState() => _VideoCommentsState();
}

class _VideoCommentsState extends State<VideoComments> {
  bool _isWriting = false;
  final ScrollController _scrollController = ScrollController();
  late BoxConstraints _commandSize;

  void _onClosePressed() => Navigator.of(context).pop();

  void _stopWriting() => setState(() {
        FocusScope.of(context).unfocus();
        _isWriting = false;
      });

  void _onStartWriting() => setState(() {
        _isWriting = true;
      });
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = isDarkMode(context);

    return Container(
      height: size.height * 0.75,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Sizes.size14,
        ),
      ),
      child: Scaffold(
        backgroundColor: isDark ? null : Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: isDark ? null : Colors.grey.shade50,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            S.of(context).commentTitle(98839, 98839),
          ),
          actions: [
            IconButton(
              onPressed: _onClosePressed,
              icon: const FaIcon(FontAwesomeIcons.xmark),
            ),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            _commandSize = constraints;
            return GestureDetector(
              onTap: _stopWriting,
              child: Stack(
                children: [
                  Scrollbar(
                    controller: _scrollController,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(
                        top: Sizes.size10,
                        bottom: Sizes.size96 + Sizes.size20,
                        left: Sizes.size16,
                        right: Sizes.size16,
                      ),
                      separatorBuilder: (context, index) => Gaps.v20,
                      itemCount: 10,
                      itemBuilder: (context, index) => Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            child: Text("헌남"),
                          ),
                          Gaps.h10,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "헌남",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: Sizes.size14,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                                Gaps.v3,
                                const Text(
                                    "That's not it l've seen the same thing but also in al cave"),
                              ],
                            ),
                          ),
                          Gaps.h10,
                          Column(
                            children: [
                              FaIcon(
                                FontAwesomeIcons.heart,
                                size: Sizes.size20,
                                color: Colors.grey.shade500,
                              ),
                              Gaps.v2,
                              Text(
                                "23.2K",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    width: _commandSize.maxWidth,
                    child: Container(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: Sizes.size16,
                          right: Sizes.size16,
                          top: Sizes.size10,
                          bottom: Sizes.size48,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 18,
                              backgroundColor: isDark
                                  ? Colors.grey.shade500
                                  : Colors.grey.shade700,
                              foregroundColor: Colors.white,
                              child: const Text("헌남"),
                            ),
                            Gaps.h10,
                            Expanded(
                              child: SizedBox(
                                child: TextField(
                                  onTap: _onStartWriting,
                                  minLines: null,
                                  maxLines: null,
                                  textInputAction: TextInputAction.newline,
                                  cursorColor: Theme.of(context).primaryColor,
                                  decoration: InputDecoration(
                                    hintText: "Write a comment...",
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        Sizes.size12,
                                      ),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: isDark
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade200,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: Sizes.size12,
                                    ),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                        right: Sizes.size14,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.at,
                                            color: isDark
                                                ? Colors.grey.shade500
                                                : Colors.grey.shade900,
                                          ),
                                          Gaps.h14,
                                          FaIcon(
                                            FontAwesomeIcons.gift,
                                            color: isDark
                                                ? Colors.grey.shade500
                                                : Colors.grey.shade900,
                                          ),
                                          Gaps.h14,
                                          FaIcon(
                                            FontAwesomeIcons.faceSmile,
                                            color: isDark
                                                ? Colors.grey.shade500
                                                : Colors.grey.shade900,
                                          ),
                                          Gaps.h14,
                                          if (_isWriting)
                                            GestureDetector(
                                              onTap: _stopWriting,
                                              child: FaIcon(
                                                FontAwesomeIcons.circleArrowUp,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
