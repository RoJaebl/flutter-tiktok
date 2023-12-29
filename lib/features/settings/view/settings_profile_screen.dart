import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/view/widgets/settings_profile_editor.dart';
import 'package:tiktok_clone/features/settings/view/widgets/settings_profile_editor_detail.dart';
import 'package:tiktok_clone/features/settings/view_models/setting_profile_view_model.dart';

class SettingProfileScreen extends ConsumerWidget {
  const SettingProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(settingProfileProvider.notifier).getUserModel();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile Editting",
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
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
                ProfileEditor(
                  editType: EEdittingType.bio,
                  text: user.bio,
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
                ProfileEditor(
                  editType: EEdittingType.link,
                  text: user.link,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
