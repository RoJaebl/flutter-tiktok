import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:relative_time/relative_time.dart';

import 'package:tiktok_clone/common/views/widgets/theme_configuration/theme_config.dart';

import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/notification/notifications_provider.dart';
import 'package:tiktok_clone/firebase_options.dart';
import 'package:tiktok_clone/generated/l10n.dart';
import 'package:tiktok_clone/router.dart';

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
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: TikTokApp(),
    ),
  );
}

class TikTokApp extends ConsumerWidget {
  const TikTokApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
      valueListenable: lightTheme,
      builder: (context, value, child) => MaterialApp.router(
        routerConfig: ref.watch(routerProvider),
        debugShowCheckedModeBanner: false,
        title: 'TikTok Clone',
        themeMode: value ? ThemeMode.light : ThemeMode.dark,
        localizationsDelegates: const [
          S.delegate,
          AppLocalizationDelegate(),
          RelativeTimeLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('ko'),
        ],
        theme: ThemeData(
          useMaterial3: true,
          textTheme: Typography.blackMountainView,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: const Color(0xffe9435a),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xffe9435a),
          ),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey.shade500,
            indicatorColor: Colors.black,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
          ),
          listTileTheme: const ListTileThemeData(
            iconColor: Colors.black,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          textTheme: Typography.whiteMountainView,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color(0xffe9435a),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.grey.shade900,
            surfaceTintColor: Colors.grey.shade900,
            elevation: 0,
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: Sizes.size16 + Sizes.size2,
              fontWeight: FontWeight.w600,
            ),
            actionsIconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
            iconTheme: IconThemeData(
              color: Colors.grey.shade100,
            ),
          ),
          tabBarTheme: TabBarTheme(
            labelColor: Colors.white,
            indicatorColor: Colors.white,
            unselectedLabelColor: Colors.grey.shade700,
          ),
          primaryColor: const Color(0xffe9435a),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.grey.shade900,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.grey.shade800,
          ),
        ),
      ),
    );
  }
}
