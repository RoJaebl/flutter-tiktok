import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraFlashButton extends StatefulWidget {
  final CameraController controller;
  final FlashMode mode;

  const CameraFlashButton({
    super.key,
    required this.controller,
    required this.mode,
  });

  @override
  State<CameraFlashButton> createState() => _CameraFlashButton();
}

class _CameraFlashButton extends State<CameraFlashButton> {
  late final IconData _icon;
  late final FlashMode _mode;

  Future<void> _setFlashMode(FlashMode newFlashMode) async =>
      await widget.controller.setFlashMode(newFlashMode);

  void initMode() {
    _mode = widget.mode;
    switch (_mode) {
      case FlashMode.off:
        _icon = Icons.flash_off_rounded;
      case FlashMode.always:
        _icon = Icons.flash_on_rounded;
      case FlashMode.auto:
        _icon = Icons.flash_auto_rounded;
      case FlashMode.torch:
        _icon = Icons.flashlight_on_rounded;
    }
  }

  @override
  void initState() {
    super.initState();
    initMode();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: _mode == widget.controller.value.flashMode
          ? Colors.amber.shade200
          : Colors.white,
      onPressed: () => _setFlashMode(_mode),
      icon: Icon(_icon),
    );
  }
}
