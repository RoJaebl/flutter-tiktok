import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/main_navigation/main_navigation_screen.dart';
import 'package:tiktok_clone/features/authentication/login_screen.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';
import 'package:tiktok_clone/features/inbox/activity_screen.dart';
import 'package:tiktok_clone/features/inbox/chat_detail_screen.dart';
import 'package:tiktok_clone/features/inbox/chats_screen.dart';
import 'package:tiktok_clone/features/onboarding/interest_screen.dart';
import 'package:tiktok_clone/features/videos/views/video_recording_screen.dart';

final router = GoRouter(
  initialLocation: "/home",
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
    GoRoute(
      name: MainNavigationScreen.routeName,
      path: "/:tab(home|discover|inbox|profile)",
      builder: (context, state) {
        final tab = state.params["tab"]!;
        return MainNavigationScreen(
          tab: tab,
        );
      },
    ),
    GoRoute(
      name: ActivityScreen.routeName,
      path: ActivityScreen.routeURL,
      builder: (context, state) => const ActivityScreen(),
    ),
    GoRoute(
      name: ChatsScreen.routeName,
      path: ChatsScreen.routeURL,
      builder: (context, state) => const ChatsScreen(),
      routes: [
        GoRoute(
          name: ChatDetailScreen.routeName,
          path: ChatDetailScreen.routeURL,
          builder: (context, state) {
            final chatId = state.params["chatId"]!;
            return ChatDetailScreen(chatId: chatId);
          },
        )
      ],
    ),
    GoRoute(
      name: VideoRecordingScreen.routeName,
      path: VideoRecordingScreen.routeURL,
      pageBuilder: (context, state) =>
          pageBuilder(child: const VideoRecordingScreen()),
    ),
  ],
);

Page<dynamic> pageBuilder({required Widget child}) {
  return CustomTransitionPage(
    transitionDuration: const Duration(milliseconds: 200),
    child: child,
    transitionsBuilder: slidePageRoute,
  );
}

Widget slidePageRoute(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  final offsetAnimation =
      Tween(begin: const Offset(0, 1), end: Offset.zero).animate(animation);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}
