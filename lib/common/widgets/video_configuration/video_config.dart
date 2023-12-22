import 'package:flutter/material.dart';

final videoConfig = ValueNotifier(false);

/// #ChangeNotifier
// class VideoConfig extends ChangeNotifier {
//   bool autoMute = false;

//   void toggleAutoMute() {
//     autoMute = !autoMute;
//     notifyListeners();
//   }
// }

// final videoConfig = VideoConfig();

/// #InheritedWidget
// class VideoConfigData extends InheritedWidget {
//   bool autoMute;

//   final void Function() toggleMuted;

//   VideoConfigData({
//     super.key,
//     required super.child,
//     required this.autoMute,
//     required this.toggleMuted,
//   });

//   static VideoConfigData of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<VideoConfigData>()!;
//   }

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return true;
//   }
// }

// class VideoConfig extends StatefulWidget {
//   final Widget child;

//   const VideoConfig({
//     super.key,
//     required this.child,
//   });

//   @override
//   State<VideoConfig> createState() => _VideoConfigState();
// }

// class _VideoConfigState extends State<VideoConfig> {
//   bool autoMute = false;

//   void toggleMuted() {
//     setState(() {
//       autoMute = !autoMute;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return VideoConfigData(
//       toggleMuted: toggleMuted,
//       autoMute: autoMute,
//       child: widget.child,
//     );
//   }
// }
