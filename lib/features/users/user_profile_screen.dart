import 'package:flutter/material.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          stretch: true,
          pinned: true,
          backgroundColor: Colors.teal,
          elevation: 1,
          collapsedHeight: 80,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.blurBackground,
              StretchMode.zoomBackground,
            ],
            centerTitle: true,
            background: Image.asset(
              "assets/images/tiktok.jpg",
              fit: BoxFit.cover,
            ),
            title: const Text(
              "Hello",
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => Container(),
          ),
          itemExtent: 100,
        ),
      ],
    );
  }
}
