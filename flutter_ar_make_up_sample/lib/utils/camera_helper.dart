import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

Uint8List concatenatePlanes(List<Plane> planes) {
  final allBytes = WriteBuffer();
  for (var plane in planes) {
    allBytes.putUint8List(plane.bytes);
  }
  return allBytes.done().buffer.asUint8List();
}

InputImageRotation? rotationIntToImageRotation(int rotation) {
  return InputImageRotationValue.fromRawValue(rotation);
}

InputImageData buildImageData(
  CameraImage image,
  InputImageRotation rotation,
) {
  return InputImageData(
    size: Size(image.width.toDouble(), image.height.toDouble()),
    imageRotation: rotation,
    inputImageFormat: InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.yuv420,
    planeData: image.planes
        .map(
          (plane) => InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          ),
        )
        .toList(),
  );
}
