import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/videos/video_recording_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const VideoRecordingScreen(),
    ),
  ],
);

Page<dynamic> pageBuilder({required Widget page, required Column child}) {
  return CustomTransitionPage(
    child: page,
    transitionsBuilder: slidePageRoute,
  );
}

Widget slidePageRoute(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  final offsetAnimation =
      Tween(begin: const Offset(1, 0), end: Offset.zero).animate(animation);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}
