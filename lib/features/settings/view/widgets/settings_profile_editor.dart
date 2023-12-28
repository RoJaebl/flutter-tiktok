import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class SettingProfileEditor extends ConsumerWidget {
  const SettingProfileEditor({super.key});

  void _onTextChanged(String value) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("data"),
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
          onChanged: _onTextChanged,
          keyboardType: TextInputType.multiline,
          minLines: null,
          maxLines: null,
          decoration: const InputDecoration(
            constraints: BoxConstraints(minHeight: 300.0),
            hintText: "소개글을 작성하세요",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
