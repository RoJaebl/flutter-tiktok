import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/settings/view_models/setting_profile_view_model.dart';
import 'package:tiktok_clone/features/users/models/user_profile_model.dart';

final linkRegExp = RegExp(r"^https?:\/{2}[a-zA-Z0-9.a-zA-Z0-9]+\.[a-zA-Z]+");

enum EEdittingType { bio, link }

class SettingProfileEditor extends ConsumerWidget {
  final TextEditingController _textEditingController = TextEditingController();
  final EEdittingType editType;

  SettingProfileEditor({
    super.key,
    required this.editType,
  });

  void _onTextChanged(String value) {}

  void _onProfileUpload(BuildContext context, WidgetRef ref) {
    final text = _textEditingController.value.text;
    final profileUpload =
        ref.read(settingProfileProvider.notifier).profileUpload;
    if (editType == EEdittingType.link && !linkRegExp.hasMatch(text)) return;
    editType == EEdittingType.bio
        ? profileUpload(bio: text)
        : profileUpload(link: text);
    Navigator.of(context).pop();
  }

  void _onEditingCancel({
    required BuildContext context,
    required WidgetRef ref,
    required UserProfileModel user,
  }) async {
    final validText = editType == EEdittingType.bio ? user.bio : user.link;
    if (_textEditingController.text != validText) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: Text(
            "저장되지 않은 변경 사항",
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          content: const Text(
            "저장하지 않은 변경 사항이 있습니다. 변경 사항을 삭제하시겠어요?",
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              onPressed: () {
                _onPop(context);
                _onPop(context);
              },
              child: const Text(
                "내용 삭제",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            TextButton(
              onPressed: () => _onPop(context),
              child: Text(
                "수정 하기",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    } else {
      _onPop(context);
    }
  }

  void _onPop(BuildContext context) => Navigator.of(context).pop();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(settingProfileProvider).isLoading;
    final user = ref.read(settingProfileProvider.notifier).getUserModel();
    _textEditingController.text =
        editType == EEdittingType.bio ? user.bio : user.link;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("data"),
        actions: [
          isLoading
              ? Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: Sizes.size12,
                  ),
                  height: Sizes.size20,
                  width: Sizes.size20,
                  child: const CircularProgressIndicator())
              : IconButton(
                  onPressed: () => _onProfileUpload(context, ref),
                  icon: const FaIcon(
                    FontAwesomeIcons.check,
                    size: Sizes.size20,
                    color: Colors.green,
                  ),
                ),
        ],
        leading: IconButton(
          onPressed: () => _onEditingCancel(
            context: context,
            ref: ref,
            user: user,
          ),
          icon: const FaIcon(
            FontAwesomeIcons.xmark,
            size: Sizes.size20,
            color: Colors.red,
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(
          Sizes.size10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            Sizes.size7,
          ),
          border: Border.all(
            color: Colors.grey.shade300,
            width: Sizes.size1,
          ),
        ),
        child: TextField(
          controller: _textEditingController,
          onChanged: _onTextChanged,
          keyboardType: TextInputType.multiline,
          minLines: null,
          maxLines: null,
          decoration: InputDecoration(
            constraints: const BoxConstraints(minHeight: 300.0),
            hintText: editType == EEdittingType.bio
                ? "소개글을 작성하세요"
                : "https://example.com",
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            border: const OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
