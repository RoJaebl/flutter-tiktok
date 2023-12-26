// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:tiktok_clone/common/widgets/theme_configuration/theme_config.dart';
import 'package:tiktok_clone/features/authentication/repos/authentication_repo.dart';
import 'package:tiktok_clone/features/videos/view_models/playback_config_vm.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Localizations.override(
      context: context,
      locale: const Locale("es"),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Settings"),
        ),
        body: ListView(
          children: [
            ValueListenableBuilder(
              valueListenable: lightTheme,
              builder: (context, value, child) => SwitchListTile.adaptive(
                value: value,
                onChanged: (value) {
                  lightTheme.value = !lightTheme.value;
                },
                title: const Text(
                  "Light Theme",
                ),
                subtitle: const Text(
                  "Set a default theme.",
                ),
              ),
            ),
            SwitchListTile.adaptive(
              value: ref.watch(playbackConfigProvider).muted,
              onChanged: (value) =>
                  ref.read(playbackConfigProvider.notifier).setMuted(value),
              title: const Text(
                "Mute Video",
              ),
              subtitle: const Text("Videos will be muted by default"),
            ),
            SwitchListTile.adaptive(
              value: ref.watch(playbackConfigProvider).autoplay,
              onChanged: (value) =>
                  ref.read(playbackConfigProvider.notifier).setAutoplay(value),
              title: const Text(
                "Autoplay",
              ),
              subtitle: const Text("Videos will start playing automatically."),
            ),
            SwitchListTile(
              value: false,
              onChanged: (value) {},
              title: const Text(
                "Enable notifications",
              ),
            ),
            Checkbox(
              value: false,
              onChanged: (value) {},
            ),
            CheckboxListTile(
              activeColor: Colors.black,
              value: false,
              onChanged: (value) {},
              title: const Text("Enable notifications"),
            ),
            ListTile(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                );
                if (kDebugMode) {
                  print(date);
                }
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (kDebugMode) {
                  print(time);
                }
                final booking = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData(
                        appBarTheme: const AppBarTheme(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (kDebugMode) {
                  print(booking);
                }
              },
              title: const Text(
                "What is your birthday?",
              ),
            ),
            ListTile(
              onTap: () => showCupertinoDialog(
                context: context,
                builder: (context) => CupertinoAlertDialog(
                  title: const Text("Are you sure?"),
                  content: const Text("Plx dont go"),
                  actions: [
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("No"),
                    ),
                    CupertinoDialogAction(
                      onPressed: () => Navigator.of(context).pop(),
                      isDestructiveAction: true,
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              ),
              title: const Text(
                "Log out (iOS)",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            ListTile(
              onTap: () => showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  icon: const FaIcon(FontAwesomeIcons.skull),
                  title: const Text("Are you sure?"),
                  content: const Text("Plx dont go"),
                  actions: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const FaIcon(
                        FontAwesomeIcons.car,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(authRepo).signOut();
                        context.go("/");
                      },
                      child: const Text("Yes"),
                    ),
                  ],
                ),
              ),
              title: const Text(
                "Log out (Android)",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            ListTile(
              onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  title: const Text("Are you sure?"),
                  message: const Text("please dont go"),
                  actions: [
                    CupertinoActionSheetAction(
                      isDefaultAction: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Not log out"),
                    ),
                    CupertinoActionSheetAction(
                      isDestructiveAction: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Yes plz"),
                    ),
                  ],
                ),
              ),
              title: const Text(
                "Log out (iOS / bottom)",
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            const AboutListTile(),
          ],
        ),
      ),
    );
  }
}
