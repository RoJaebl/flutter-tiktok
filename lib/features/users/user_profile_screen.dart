import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/users/widgets/super_start_box.dart';
import 'package:tiktok_clone/shared/slide_route.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            centerTitle: true,
            title: const Text(
              "헌남",
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const FaIcon(
                  FontAwesomeIcons.gear,
                  size: Sizes.size20,
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(children: [
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
              FractionallySizedBox(
                widthFactor: 0.33,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(
                        Sizes.size4,
                      ),
                    ),
                  ),
                  child: const Text(
                    "Follow",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Gaps.v14,
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Sizes.size32,
                ),
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
              Container(
                decoration: BoxDecoration(
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.grey.shade200,
                      width: 0.5,
                    ),
                  ),
                ),
                child: TabBar(
                  indicatorColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: const EdgeInsets.only(
                    top: Sizes.size10,
                    bottom: Sizes.size10,
                  ),
                  labelColor: Colors.black,
                  dividerHeight: 0.5,
                  dividerColor: Colors.grey.shade200,
                  tabs: const [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.size20,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.tableCells,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Sizes.size20,
                      ),
                      child: FaIcon(
                        FontAwesomeIcons.heart,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.size6,
                        horizontal: Sizes.size6,
                      ),
                      itemCount: 20,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: Sizes.size10,
                        crossAxisSpacing: Sizes.size10,
                        childAspectRatio: 9 / 20,
                      ),
                      itemBuilder: (context, index) => Column(
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Sizes.size4,
                              ),
                            ),
                            child: AspectRatio(
                              aspectRatio: 9 / 16,
                              child: FadeInImage.assetNetwork(
                                placeholder: "assets/images/tiktok.jpg",
                                image:
                                    "https://source.unsplash.com/random/$index",
                                placeholderFit: BoxFit.contain,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Gaps.v10,
                          const Text(
                            "This is a very long caption for my tiktok that im upload just now currently",
                            style: TextStyle(
                              fontSize: Sizes.size16 + Sizes.size2,
                              fontWeight: FontWeight.bold,
                              height: 1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gaps.v8,
                          DefaultTextStyle(
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  radius: 12,
                                  backgroundImage: NetworkImage(
                                      "https://avatars.githubusercontent.com/u/40203276?v=4"),
                                ),
                                Gaps.h4,
                                const Expanded(
                                  child: Text(
                                    "My avatar is going to be very long",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Gaps.h4,
                                FaIcon(
                                  FontAwesomeIcons.heart,
                                  size: Sizes.size16,
                                  color: Colors.grey.shade600,
                                ),
                                Gaps.h2,
                                const Text(
                                  "2.5M",
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
              ),
            ]),
          ),
        ],
        physics: const BouncingScrollPhysics(),
      ),
    );
  }
}
