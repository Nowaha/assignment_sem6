import 'dart:io';

import 'package:assignment_sem6/data/entity/impl/resource.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final Resource resource;

  const CustomVideoPlayer({super.key, required this.resource});

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  File? _tempFile;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  void _initVideo() async {
    final ext = widget.resource.originalExtension.toLowerCase();
    final tempDir = await getTemporaryDirectory();
    _tempFile = File('${tempDir.path}/${widget.resource.name}.$ext');

    if (await _tempFile!.exists()) {
      await _tempFile!.delete();
    }
    await _tempFile!.writeAsBytes(widget.resource.data);

    final controller = VideoPlayerController.file(_tempFile!);
    await controller.initialize();

    final chewieController = ChewieController(
      videoPlayerController: controller,
      aspectRatio: controller.value.aspectRatio,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            "Error loading video: $errorMessage",
            style: TextStyle(color: Colors.red),
          ),
        );
      },
    );

    setState(() {
      _controller = controller;
      _chewieController = chewieController;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _chewieController?.dispose();
    _tempFile?.exists().then((exists) {
      if (exists) {
        _tempFile?.delete();
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_chewieController == null ||
        !_chewieController!.videoPlayerController.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Chewie(controller: _chewieController!);
  }
}
