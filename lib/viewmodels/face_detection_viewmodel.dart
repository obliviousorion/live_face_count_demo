import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/camera_providers.dart';
import '../utils/image_converter.dart';

class FaceDetectionViewModel {
  final WidgetRef ref;
  bool isDetecting = false;

  FaceDetectionViewModel(this.ref);

  Future<void> processImage(CameraImage image, BuildContext context) async {
    final faceDetector = ref.read(faceDetectorProvider);
    final inputImage = ImageConverter.convertCameraImage(image, context, ref);

    if (inputImage == null) {
      isDetecting = false;
      return;
    }

    try {
      final faces = await faceDetector.processImage(inputImage);
      ref.read(faceCountProvider.notifier).state = faces.length;
    } catch (e) {
      debugPrint('Error processing image: $e');
    } finally {
      isDetecting = false;
    }
  }

  Future<void> startFaceDetection(BuildContext context) async {
    final cameraControllerAsync = ref.read(cameraControllerProvider);
    if (cameraControllerAsync.value == null) return;

    final cameraController = cameraControllerAsync.value!;
    await cameraController.initialize();

    await cameraController.startImageStream((CameraImage image) {
      if (isDetecting) return;
      isDetecting = true;
      processImage(image, context);
    });
  }
}
