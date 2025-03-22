import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

final selectedVideoProvider = StateProvider<File?>((ref) => null);

final videoPlayerControllerProvider =
    FutureProvider.autoDispose<VideoPlayerController?>((ref) async {
  final videoFile = ref.watch(selectedVideoProvider);
  if (videoFile == null) return null;

  final controller = VideoPlayerController.file(videoFile);
  await controller.initialize();
  controller.play();

  ref.onDispose(() {
    controller.dispose();
  });

  return controller;
});
