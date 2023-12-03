import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Settings"),
        ),
        body: const Column(
          children: [
            CupertinoActivityIndicator(),
            CircularProgressIndicator(),
            CircularProgressIndicator.adaptive(),
          ],
        ));
  }
}
