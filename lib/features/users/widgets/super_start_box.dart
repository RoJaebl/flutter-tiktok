import 'package:flutter/material.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class SuperStarBox extends StatelessWidget {
  final String title;
  final String subTitle;
  final bool divider;

  const SuperStarBox(
      {super.key,
      required this.title,
      required this.subTitle,
      this.divider = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Sizes.size18,
              ),
            ),
            Gaps.v2,
            Text(
              subTitle,
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        if (divider)
          VerticalDivider(
            width: Sizes.size32,
            thickness: Sizes.size1,
            color: Colors.grey.shade400,
            indent: Sizes.size14,
            endIndent: Sizes.size14,
          ),
      ],
    );
  }
}
