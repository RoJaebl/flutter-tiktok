import 'package:flutter/material.dart';

const avatarUri = "https://avatars.githubusercontent.com/u/40203276?v=4";
const nikoaAvatarUri = "https://avatars.githubusercontent.com/u/3612017?v=4";

PageRouteBuilder<dynamic> slideRoute({required Widget screen}) {
  return PageRouteBuilder(
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      late final Animation<Offset> panelAnimation = Tween(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation);

      return SlideTransition(
        position: panelAnimation,
        child: child,
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) => screen,
  );
}
