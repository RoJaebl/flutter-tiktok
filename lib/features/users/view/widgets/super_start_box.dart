import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/constants/breakpoints.dart';
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

class SuperStartAcount extends StatelessWidget {
  final double width;
  const SuperStartAcount({super.key, required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Sizes.size48,
      width: width,
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              alignment: Alignment.center,
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
              ),
            ),
          ),
          Gaps.h5,
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size12,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    Sizes.size4,
                  ),
                ),
                border: Border.all(
                  color: Colors.grey.shade600,
                  width: 0.5,
                ),
              ),
              child: const FaIcon(
                FontAwesomeIcons.youtube,
                size: Sizes.size24,
              ),
            ),
          ),
          Gaps.h5,
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(
                vertical: Sizes.size12,
              ),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(
                    Sizes.size4,
                  ),
                ),
                border: Border.all(
                  color: Colors.grey.shade600,
                  width: 0.5,
                ),
              ),
              child: const FaIcon(
                FontAwesomeIcons.caretDown,
                size: Sizes.size24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
