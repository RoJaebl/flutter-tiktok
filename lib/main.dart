import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/authentication/sign_up_screen.dart';

import 'package:tiktok_clone/features/main_navigation/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
    ],
  );

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark,
  );

  runApp(const TikTokApp());
}

class TikTokApp extends StatelessWidget {
  const TikTokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TikTok Clone',
      themeMode: ThemeMode.system,
      theme: FlexThemeData.light(scheme: FlexScheme.indigo),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.indigo),
      home: const SignUpScreen(),
    );
  }
}
