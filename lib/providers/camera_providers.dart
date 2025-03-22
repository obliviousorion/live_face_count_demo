import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

final cameraControllerProvider =
    FutureProvider.autoDispose<CameraController?>((ref) async {
  final camerasAsync = ref.watch(camerasProvider);

  return camerasAsync.when(
    loading: () => null,
    error: (_, __) => null,
    data: (cameras) {
      if (cameras.isEmpty) return null;

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
      );

      ref.onDispose(() {
        controller.dispose();
      });

      return controller;
    },
  );
});

final camerasProvider = FutureProvider<List<CameraDescription>>((ref) async {
  return await availableCameras();
});

final faceCountProvider = StateProvider<int>((ref) => 0);

final faceDetectorProvider = Provider<FaceDetector>((ref) {
  final detector = GoogleMlKit.vision.faceDetector();
  ref.onDispose(() => detector.close());
  return detector;
});
