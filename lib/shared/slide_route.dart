import 'package:flutter/material.dart';

PageRouteBuilder<dynamic> slideRoute(Widget screen) {
  return PageRouteBuilder(
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        SlideTransition(
      position: animation.drive(
        Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(
          CurveTween(
            curve: Curves.ease,
          ),
        ),
      ),
      child: child,
    ),
    pageBuilder: (context, animation, secondaryAnimation) => screen,
  );
}
