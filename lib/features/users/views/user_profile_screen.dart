import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/views/settings_profile_screen.dart';
import 'package:tiktok_clone/features/settings/views/settings_screen.dart';
import 'package:tiktok_clone/features/users/views/widgets/avatar.dart';
import 'package:tiktok_clone/features/users/view_models/users_view_model.dart';
import 'package:tiktok_clone/features/users/views/widgets/persistent_tab_bar.dart';
import 'package:tiktok_clone/features/users/views/widgets/super_start_box.dart';
import 'package:tiktok_clone/common/shared/slide_route.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  final String username;
  final String tab;

  const UserProfileScreen({
    super.key,
    required this.username,
    required this.tab,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  bool _textOpen = false;
  void _onGearPressed() => Navigator.of(context).push(
        slideRoute(screen: const SettingScreen()),
      );

  void _onEditPressed() => Navigator.of(context).push(
        slideRoute(
          screen: const SettingProfileScreen(),
        ),
      );

  void _onToggleTextAccordion() => setState(() {
        _textOpen = !_textOpen;
      });

  @override
  Widget build(BuildContext context) {
    return ref.watch(usersProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          data: (data) => Scaffold(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            body: SafeArea(
              child: DefaultTabController(
                initialIndex: widget.tab == "likes" ? 1 : 0,
                length: 2,
                child: NestedScrollView(
                  headerSliverBuilder: (context, innerBoxIsScrolled) {
                    return [
                      SliverAppBar(
                        centerTitle: true,
                        title: Text(
                          data.name,
                        ),
                        actions: [
                          IconButton(
                            onPressed: _onEditPressed,
                            icon: const FaIcon(
                              FontAwesomeIcons.pen,
                              size: Sizes.size20,
                            ),
                          ),
                          IconButton(
                            onPressed: _onGearPressed,
                            icon: const FaIcon(
                              FontAwesomeIcons.gear,
                              size: Sizes.size20,
                            ),
                          ),
                        ],
                      ),
                      SliverToBoxAdapter(
                        child: Container(
                            width: 300,
                            constraints: const BoxConstraints(
                              maxWidth: 200,
                            ),
                            child: Column(
                              children: [
                                Gaps.v20,
                                Avatar(
                                  name: data.name,
                                  hasAvatar: data.hasAvatar,
                                  uid: data.uid,
                                  avatarURL: data.avatarURL,
                                ),
                                Gaps.v20,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "@${data.name}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: Sizes.size18,
                                      ),
                                    ),
                                    Gaps.h5,
                                    FaIcon(
                                      FontAwesomeIcons.solidCircleCheck,
                                      size: Sizes.size16,
                                      color: Colors.blue.shade500,
                                    ),
                                  ],
                                ),
                                Gaps.v24,
                                const SizedBox(
                                  height: Sizes.size48,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SuperStarBox(
                                        title: "97",
                                        subTitle: "Following",
                                        divider: true,
                                      ),
                                      SuperStarBox(
                                        title: "10M",
                                        subTitle: "Followers",
                                        divider: true,
                                      ),
                                      SuperStarBox(
                                        title: "194.3M",
                                        subTitle: "Likes",
                                      ),
                                    ],
                                  ),
                                ),
                                Gaps.v14,
                                const SuperStartAcount(
                                  width: 300,
                                ),
                                Gaps.v14,
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    children: [
                                      Text(
                                        data.bio,
                                        textAlign: TextAlign.center,
                                        maxLines: _textOpen ? null : 3,
                                      ),
                                      TextButton(
                                        onPressed: _onToggleTextAccordion,
                                        style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateColor.resolveWith(
                                            (states) => Colors.transparent,
                                          ),
                                          enableFeedback: false,
                                        ),
                                        child: Text(
                                          _textOpen ? "접기" : "...더보기",
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Gaps.v14,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const FaIcon(
                                      FontAwesomeIcons.link,
                                      size: Sizes.size12,
                                    ),
                                    Gaps.h4,
                                    Text(
                                      data.link,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                Gaps.v20,
                              ],
                            )),
                      ),
                      SliverPersistentHeader(
                        delegate: PersistentTabBar(),
                        pinned: true,
                      ),
                    ];
                  },
                  body: TabBarView(
                    children: [
                      GridView.builder(
                        padding: EdgeInsets.zero,
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        itemCount: 20,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > Breakpoints.md
                                  ? 5
                                  : 3,
                          mainAxisSpacing: Sizes.size2,
                          crossAxisSpacing: Sizes.size2,
                          childAspectRatio: 9 / 14,
                        ),
                        itemBuilder: (context, index) => Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 9 / 14,
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/tiktok.jpg",
                                image:
                                    "https://source.unsplash.com/random/$index",
                                placeholderFit: BoxFit.contain,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const Positioned(
                              left: Sizes.size3,
                              bottom: Sizes.size3,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: Sizes.size24,
                                  ),
                                  Text(
                                    "4.1M",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Center(
                        child: Text("Page one"),
                      ),
                    ],
                  ),
                  physics: const BouncingScrollPhysics(),
                ),
              ),
            ),
          ),
        );
  }
}
