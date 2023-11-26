import 'package:flutter/material.dart';

class VideoTimelineScreen extends StatefulWidget {
  const VideoTimelineScreen({super.key});

  @override
  State<VideoTimelineScreen> createState() => _VideoTimelineScreenState();
}

class _VideoTimelineScreenState extends State<VideoTimelineScreen> {
  int _itemCount = 4;

  List<Color> colors = [
    Colors.blue,
    Colors.teal,
    Colors.yellow,
    Colors.pink,
  ];

  void _onPageChanged(int page) {
    if (page == colors.length - 1) {
      _itemCount += 4;
      colors.addAll([
        Colors.blue,
        Colors.teal,
        Colors.yellow,
        Colors.pink,
      ]);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: _itemCount,
      onPageChanged: _onPageChanged,
      itemBuilder: (context, index) => Container(
        color: colors[index],
        child: Center(
            child: Text(
          "Screen $index",
          style: const TextStyle(
            fontSize: 68,
          ),
        )),
      ),
    );
  }
}
