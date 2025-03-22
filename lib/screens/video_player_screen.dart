import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/camera_providers.dart';
import '../providers/video_providers.dart';
import '../viewmodels/face_detection_viewmodel.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  ConsumerState<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  late final FaceDetectionViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    final videoPlayerControllerAsync = ref.watch(videoPlayerControllerProvider);
    final cameraControllerAsync = ref.watch(cameraControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Video Player')),
      body: videoPlayerControllerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (videoController) {
          if (videoController == null) {
            return const Center(child: Text('No video selected'));
          }
          return Stack(children: [
            // ... existing video player layout ...
          ]);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _viewModel = FaceDetectionViewModel(ref);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.startFaceDetection(context);
    });
  }
}
