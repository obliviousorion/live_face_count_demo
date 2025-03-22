import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

import '../providers/camera_providers.dart';

class ImageConverter {
  static InputImage? convertCameraImage(
      CameraImage image, BuildContext context, WidgetRef ref) {
    final cameraControllerAsync = ref.read(cameraControllerProvider);
    if (cameraControllerAsync.value == null) return null;

    final camera = cameraControllerAsync.value!.description;
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotation.rotation0deg;
    } else {
      final deviceOrientation = MediaQuery.of(context).orientation;
      final rotationCompensation =
          deviceOrientation == Orientation.portrait ? 0 : 90;

      if (camera.lensDirection == CameraLensDirection.front) {
        rotation = InputImageRotationValue.fromRawValue(
            (sensorOrientation + rotationCompensation) % 360);
      } else {
        rotation = InputImageRotationValue.fromRawValue(
            (sensorOrientation - rotationCompensation + 360) % 360);
      }
    }
    if (rotation == null) return null;

    final format =
        Platform.isAndroid ? InputImageFormat.nv21 : InputImageFormat.bgra8888;

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }
}
