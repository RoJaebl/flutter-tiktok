import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/settings_screen.dart';
import 'package:tiktok_clone/features/users/widgets/persistent_tab_bar.dart';
import 'package:tiktok_clone/features/users/widgets/super_start_box.dart';
import 'package:tiktok_clone/shared/slide_route.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  void _onGearPressed() => Navigator.of(context).push(
        slideRoute(screen: const SettingScreen()),
      );

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                centerTitle: true,
                title: const Text(
                  "헌남",
                ),
                actions: [
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
                        const CircleAvatar(
                          radius: 50,
                          foregroundImage: NetworkImage(avatarUri),
                          child: Text("헌남"),
                        ),
                        Gaps.v20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "@헌남",
                              style: TextStyle(
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
                        const SizedBox(
                          width: 300,
                          child: Text(
                            "All highlights and where to watch live matches on FIFA+ I wonder how it would look",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Gaps.v14,
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.link,
                              size: Sizes.size12,
                            ),
                            Gaps.h4,
                            Text(
                              "https://nomadcorders.co",
                              style: TextStyle(
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
                  crossAxisCount: width > Breakpoints.md ? 5 : 3,
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
                        image: "https://source.unsplash.com/random/$index",
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
    );
  }
}
