import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/onboarding/interest_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: SignUpScreen.routeName,
      path: SignUpScreen.routeURL,
      builder: (context, state) => const SignUpScreen(),
    ),
    GoRoute(
      name: LoginScreen.routeName,
      path: LoginScreen.routeURL,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: InterestScreen.routeName,
      path: InterestScreen.routeURL,
      builder: (context, state) => const InterestScreen(),
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
