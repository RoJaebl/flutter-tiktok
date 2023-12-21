import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/video_preview_scree.dart';
import 'package:tiktok_clone/features/videos/widgets/video_camera_func.dart';
import 'package:tiktok_clone/shared/slide_route.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
    with TickerProviderStateMixin {
  bool _hasPermission = false;
  bool _cameraDenied = false;
  bool _micDenied = false;

  bool _isSelfieMode = false;

  late final AnimationController _buttonsAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(
      milliseconds: 200,
    ),
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonsAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
          vsync: this,
          duration: const Duration(seconds: 2),
          lowerBound: 0.0,
          upperBound: 1.0);

  late CameraController _cameraController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _checkPermission() async {
    _cameraDenied = await Permission.camera.isDenied ||
        await Permission.camera.isPermanentlyDenied;
    _micDenied = await Permission.microphone.isDenied ||
        await Permission.microphone.isPermanentlyDenied;

    if (!_cameraDenied && !_micDenied) {
      _hasPermission = true;
      await initCamera();
      setState(() {});
    }
  }

  void openAppSetting() async => await openAppSettings();

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
      cameras[_isSelfieMode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );

    await _cameraController.initialize();
    await _cameraController.prepareForVideoRecording();
    _cameraController.addListener(() {
      setState(() {});
    });
  }

  Future<void> initPermissions() async {
    await Permission.camera.request();
    await Permission.microphone.request();
    await _checkPermission();
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _buttonsAnimationController.dispose();
    _cameraController.dispose();
    super.dispose();
  }

  Future<void> toggleSelfieMode() async {
    _isSelfieMode = !_isSelfieMode;
    await initCamera();
    setState(() {});
  }

  Future<void> _startRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;

    await _cameraController.startVideoRecording();

    _buttonsAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonsAnimationController.reverse();
    _progressAnimationController.reset();

    if (!mounted) return;

    final video = await _cameraController.stopVideoRecording();
    Navigator.push(
      context,
      slideRoute(
        screen: VideoPreviewScreen(video: video, isPicked: false),
      ),
    );
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video == null || !mounted) return;

    Navigator.push(
      context,
      slideRoute(
        screen: VideoPreviewScreen(video: video, isPicked: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Theme.of(context).primaryColor,
        backgroundColor: Colors.white,
        onRefresh: _checkPermission,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: !_hasPermission || !_cameraController.value.isInitialized
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Initializing...",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Sizes.size20,
                      ),
                    ),
                    Gaps.v20,
                    ElevatedButton(
                      onPressed: () => openAppSetting(),
                      child: const Text("Open app settings"),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          _refreshIndicatorKey.currentState!.show(),
                      child: const Text("Permission reflash"),
                    ),
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    CameraPreview(_cameraController),
                    Positioned(
                      top: Sizes.size32,
                      right: Sizes.size20,
                      child: Column(
                        children: [
                          IconButton(
                            color: Colors.white,
                            onPressed: toggleSelfieMode,
                            icon: const Icon(
                              Icons.cameraswitch,
                            ),
                          ),
                          Gaps.v10,
                          CameraFlashButton(
                              controller: _cameraController,
                              mode: FlashMode.off),
                          Gaps.v10,
                          CameraFlashButton(
                              controller: _cameraController,
                              mode: FlashMode.always),
                          Gaps.v10,
                          CameraFlashButton(
                              controller: _cameraController,
                              mode: FlashMode.auto),
                          Gaps.v10,
                          CameraFlashButton(
                              controller: _cameraController,
                              mode: FlashMode.torch),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: Sizes.size40,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTapDown: _startRecording,
                            onTapUp: (details) => _stopRecording(),
                            child: ScaleTransition(
                              scale: _buttonAnimation,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: Sizes.size80 + Sizes.size14,
                                    height: Sizes.size80 + Sizes.size14,
                                    child: CircularProgressIndicator(
                                      color: Colors.red.shade400,
                                      strokeWidth: Sizes.size6,
                                      value: _progressAnimationController.value,
                                    ),
                                  ),
                                  Container(
                                    width: Sizes.size80,
                                    height: Sizes.size80,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: IconButton(
                                onPressed: _onPickVideoPressed,
                                icon: const FaIcon(
                                  FontAwesomeIcons.image,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
