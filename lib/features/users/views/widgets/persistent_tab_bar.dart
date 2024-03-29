import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/views/widgets/theme_configuration/theme_config.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class PersistentTabBar extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ValueListenableBuilder(
      valueListenable: lightTheme,
      builder: (context, value, child) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          border: Border.symmetric(
            horizontal: BorderSide(
              color: value ? Colors.grey.shade200 : Colors.grey.shade700,
              width: 0.5,
            ),
          ),
        ),
        child: TabBar(
          indicatorColor: Theme.of(context).tabBarTheme.indicatorColor,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding: const EdgeInsets.only(
            top: Sizes.size10,
            bottom: Sizes.size10,
          ),
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
    );
  }

  @override
  double get maxExtent => 47;

  @override
  double get minExtent => 47;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
