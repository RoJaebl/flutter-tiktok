// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tiktok_clone/common/widgets/theme_configuration/theme_config.dart';
import 'package:tiktok_clone/common/widgets/video_configuration/video_config.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _notifications = false;

  void _onNotificationsChanged(bool? newValue) {
    if (newValue == null) return;
    setState(() {
      _notifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              valueListenable: videoConfig,
              builder: (context, value, child) => SwitchListTile.adaptive(
                value: value,
                onChanged: (value) {
                  videoConfig.value = !videoConfig.value;
                },
                title: const Text(
                  "Mute video",
                ),
                subtitle: const Text(
                  "Videos will be muted by default.",
                ),
              ),
            ),
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
            SwitchListTile(
              value: _notifications,
              onChanged: _onNotificationsChanged,
              title: const Text(
                "Enable notifications",
              ),
            ),
            Checkbox(
              value: _notifications,
              onChanged: _onNotificationsChanged,
            ),
            CheckboxListTile(
              activeColor: Colors.black,
              value: _notifications,
              onChanged: _onNotificationsChanged,
              title: const Text("Enable notifications"),
            ),
            ListTile(
              onTap: () async {
                if (!mounted) return;
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1980),
                  lastDate: DateTime(2030),
                );
                if (kDebugMode) {
                  print(date);
                }
                if (!mounted) return;
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (kDebugMode) {
                  print(time);
                }
                if (!mounted) return;
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
                      onPressed: () => Navigator.of(context).pop(),
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
