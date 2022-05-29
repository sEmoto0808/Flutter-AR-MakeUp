import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_make_up_sample/pages/camera_live_feed_view.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../sample/painters/face_detector_painter.dart';

/// カメラを起動して顔検出する画面
class FaceDetectionPage extends StatefulWidget {
  final CameraDescription camera;

  const FaceDetectionPage({
    Key? key,
    required this.camera,
  }) : super(key: key);

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  /// 顔検出
  late final FaceDetector _faceDetector;
  var isImageStreamStarted = false;
  CustomPaint? _customPaint;

  @override
  void initState() {
    final faceDetectorOptions = FaceDetectorOptions(
      enableLandmarks: true,
      enableTracking: true,
      enableClassification: true,
      enableContours: true,
    );
    _faceDetector = FaceDetector(options: faceDetectorOptions);

    super.initState();
  }

  @override
  void dispose() {
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection'),
      ),
      body: Stack(
        children: [
          CameraLiveFeedView(
            camera: widget.camera,
            customPaint: _customPaint,
            onImage: (inputImage) {
              _processImage(inputImage);
            },
          ),
          if (_customPaint != null) _customPaint!,
        ],
      ),
    );
  }

  Future<void> _processImage(InputImage inputImage) async {
    if (isImageStreamStarted) return;
    isImageStreamStarted = true;

    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);
    } else {
      // TODO: set _customPaint to draw boundingRect on top of image
      _customPaint = null;
    }

    isImageStreamStarted = false;
    if (mounted) {
      setState(() {});
    }
  }
}
