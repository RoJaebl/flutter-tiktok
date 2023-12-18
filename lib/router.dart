import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/features/authentication/email_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/authentication/username_screen.dart';
import 'package:tiktok_clone/features/users/user_profile_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      name: SignUpScreen.routeName,
      path: SignUpScreen.routeURL,
      builder: (context, state) => const SignUpScreen(),
      routes: [
        GoRoute(
          name: UserNameScreen.routeNmae,
          path: UserNameScreen.routeURL,
          pageBuilder: (context, state) => pageBuilder(
            page: const UserNameScreen(),
          ),
          routes: [
            GoRoute(
              name: EmailScreen.routeName,
              path: EmailScreen.routeURL,
              builder: (context, state) {
                final args = state.extra as EmailScreenArgs;
                return EmailScreen(username: args.username);
              },
            ),
          ],
        ),
      ],
    ),
    // GoRoute(
    //   path: LoginScreen.routeName,
    //   builder: (context, state) => const LoginScreen(),
    // ),
    // GoRoute(
    //   name: "username_screen",
    //   path: UserNameScreen.routeName,
    //   pageBuilder: (context, state) => pageBuilder(
    //     page: const UserNameScreen(),
    //   ),
    // ),
    // GoRoute(
    //   path: EmailScreen.routeNmae,
    //   builder: (context, state) {
    //     final args = state.extra as EmailScreenArgs;
    //     return EmailScreen(username: args.username);
    //   },
    // ),
    GoRoute(
      path: "/users/:username",
      builder: (context, state) {
        final username = state.params['username'];
        final tab = state.queryParams["show"];
        return UserProfileScreen(username: username!, tab: tab!);
      },
    ),
  ],
);

Page<dynamic> pageBuilder({required Widget page}) {
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
