import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/camera_providers.dart';
import '../providers/video_providers.dart';
import 'video_player_screen.dart';

class FileSelectionScreen extends ConsumerWidget {
  const FileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camerasAsync = ref.watch(camerasProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Select Video File')),
      body: Center(
        child: camerasAsync.when(
          loading: () => const CircularProgressIndicator(),
          error: (err, stack) => Text('Error: $err'),
          data: (cameras) => ElevatedButton(
            onPressed: () => _selectVideo(context, ref),
            child: const Text('Select Video'),
          ),
        ),
      ),
    );
  }

  Future<void> _selectVideo(BuildContext context, WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null && result.files.single.path != null) {
      ref.read(selectedVideoProvider.notifier).state =
          File(result.files.single.path!);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VideoPlayerScreen()),
      );
    }
  }
}
