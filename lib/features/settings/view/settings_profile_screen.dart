import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/shared/slide_route.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/view/widgets/settings_profile_editor.dart';

class SettingProfileScreen extends ConsumerWidget {
  const SettingProfileScreen({super.key});

  void _onBioDescription(BuildContext context) {
    debugPrint("editor");
    Navigator.push(
      context,
      slideRoute(
        screen: const SettingProfileEditor(),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile Editting",
        ),
      ),
      body: Center(
        child: Scrollbar(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(
              Sizes.size10,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size5,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(
                Sizes.size10,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _onBioDescription(context),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: Sizes.size10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.size5,
                      ),
                      decoration: const BoxDecoration(),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "소개",
                          ),
                          Text(
                            "반가워요",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: Sizes.size10,
                  ),
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: Sizes.size1,
                    ),
                  )),
                ),
                GestureDetector(
                  onTap: () {
                    print("링크");
                  },
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: Sizes.size10,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: Sizes.size5,
                      ),
                      decoration: const BoxDecoration(),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "소개",
                          ),
                          Text(
                            "반가워요",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
