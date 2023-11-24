import 'package:flutter/material.dart';

class SflScreen extends StatefulWidget {
  const SflScreen({super.key});

  @override
  State<SflScreen> createState() => _SflScreenState();
}

class _SflScreenState extends State<SflScreen> {
  int _increase = 0;
  void _onTap() => setState(() {
        _increase += 1;
      });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "$_increase",
            style: const TextStyle(
              fontSize: 48,
            ),
          ),
          TextButton(
            onPressed: _onTap,
            child: const Text("+"),
          ),
        ],
      ),
    );
  }
}
