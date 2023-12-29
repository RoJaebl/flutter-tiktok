import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/common/shared/slide_route.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/view/widgets/settings_profile_editor_detail.dart';
import 'package:tiktok_clone/features/settings/view_models/setting_profile_view_model.dart';

class ProfileEditor extends ConsumerWidget {
  final EEdittingType editType;
  final String text;
  const ProfileEditor({
    super.key,
    required this.editType,
    required this.text,
  });

  void _onBioDescription(BuildContext context) {
    Navigator.push(
      context,
      slideRoute(
        screen: SettingProfileEditor(editType: editType),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(settingProfileProvider.notifier).getUserModel();
    return GestureDetector(
      onTap: () => _onBioDescription(
        context,
      ),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                editType == EEdittingType.bio ? "소개" : "링크",
              ),
              Text(
                editType == EEdittingType.bio ? user.bio : user.link,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
