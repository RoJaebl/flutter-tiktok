import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/videos/view_models/upload_video_viwe_model.dart';
import 'package:video_player/video_player.dart';

class VideoPreviewScreen extends ConsumerStatefulWidget {
  final XFile video;
  final bool isPicked;

  const VideoPreviewScreen({
    super.key,
    required this.video,
    required this.isPicked,
  });

  @override
  VideoPreviewScreenState createState() => VideoPreviewScreenState();
}

class VideoPreviewScreenState extends ConsumerState<VideoPreviewScreen>
    with SingleTickerProviderStateMixin {
  late final VideoPlayerController _videoPlayerController;
  late final AnimationController _animationController = AnimationController(
    vsync: this,
    lowerBound: 0.0,
    upperBound: 1.0,
    value: 0.0,
    duration: const Duration(milliseconds: 300),
  );
  late final Animation<Offset> _slidAnimation = Tween(
    begin: const Offset(0.0, 1.0),
    end: Offset.zero,
  ).animate(_animationController);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _savedVideo = false;

  Future<void> _initVideo() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true);
    await _videoPlayerController.play();

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future<void> _saveToGallery() async {
    if (_savedVideo) return;

    await GallerySaver.saveVideo(
      widget.video.path,
      albumName: "TikTok Clone!",
    );
    _savedVideo = true;
    setState(() {});
  }

  void _onUploadPressed() {
    ref.read(uploadVideoProvider.notifier).uploadVideo(
          File(widget.video.path),
          context,
          title: _titleController.text,
          description: _descriptionController.text,
        );
  }

  void _onDragDescription(DragUpdateDetails details) {
    if (-20.0 < details.delta.dy) {
      _animationController.forward();
    }
    if (20.0 < details.delta.dy) {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          "Preview video",
        ),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(_savedVideo
                  ? FontAwesomeIcons.check
                  : FontAwesomeIcons.floppyDisk),
            ),
          IconButton(
            onPressed: ref.watch(uploadVideoProvider).isLoading
                ? () {}
                : _onUploadPressed,
            icon: ref.watch(uploadVideoProvider).isLoading
                ? const CircularProgressIndicator()
                : const FaIcon(
                    FontAwesomeIcons.cloudArrowUp,
                  ),
          ),
        ],
      ),
      body: _videoPlayerController.value.isInitialized
          ? GestureDetector(
              onVerticalDragUpdate: _onDragDescription,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: VideoPlayer(_videoPlayerController),
                  ),
                  Positioned(
                    bottom: 0,
                    child: SlideTransition(
                      position: _slidAnimation,
                      child: Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.all(
                          Sizes.size20,
                        ),
                        decoration: const BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(
                              Sizes.size24,
                            ),
                          ),
                          color: Colors.white,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "제목",
                              ),
                              Gaps.v10,
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: Sizes.size1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Sizes.size10,
                                  ),
                                ),
                                child: TextField(
                                  controller: _titleController,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.transparent,
                                    constraints: BoxConstraints(),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: Sizes.size14,
                                        horizontal: Sizes.size8),
                                    hintText: "영상 제목을 입력하세요",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                              Gaps.v10,
                              const Text(
                                "설명",
                              ),
                              Gaps.v10,
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: Sizes.size1,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    Sizes.size10,
                                  ),
                                ),
                                child: TextField(
                                  controller: _descriptionController,
                                  keyboardType: TextInputType.multiline,
                                  minLines: null,
                                  maxLines: null,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.transparent,
                                    constraints: BoxConstraints(
                                      minHeight: 120.0,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: Sizes.size14,
                                        horizontal: Sizes.size8),
                                    hintText: "설명을 입력하세요",
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
