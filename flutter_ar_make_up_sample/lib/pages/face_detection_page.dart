import 'dart:math';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ar_make_up_sample/utils/camera_helper.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

/// カメラを起動して顔検出する画面
class FaceDetectionPage extends StatefulWidget {
  final CameraDescription camera;

  const FaceDetectionPage({Key? key, required this.camera}) : super(key: key);

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  late final CameraController _controller;

  /// 顔検出
  late final FaceDetector _faceDetector;
  var isImageStreamStarted = false;

  @override
  void initState() {
    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _controller.initialize().then(
      (value) {
        if (!mounted) {
          return;
        }
        setState(() {});
      },
    ).catchError(
      (Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              print('User denied camera access.');
              break;
            default:
              print('Handle other errors.');
              break;
          }
        }
      },
    );

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
    _controller.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection'),
      ),
      body: _controller.value.isInitialized
          ? CameraPreview(_controller)
          : Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: isImageStreamStarted ? _stop : _start,
        child: isImageStreamStarted
            ? const Icon(Icons.stop)
            : const Icon(Icons.start),
      ),
    );
  }

  /// https://www.techaas.net/post/flutter-mlkit-realtime/

  void _start() {
    _controller.startImageStream(_processImage);
    setState(() {
      isImageStreamStarted = true;
    });
  }

  void _stop() {
    _controller.stopImageStream();
    setState(() {
      isImageStreamStarted = false;
    });
  }

  void _processImage(CameraImage image) async {
    // print('CameraImage: $image');
    // final numBytes = image.planes.fold<int>(0, (count, plane) => count += plane.bytes.length);
    final inputImage = InputImage.fromBytes(
      bytes: concatenatePlanes(image.planes),
      inputImageData: buildImageData(
        image,
        rotationIntToImageRotation(0)!,
      ),
    );

    final faces = await _faceDetector.processImage(inputImage);

    // for (var face in faces) {
    //   final Rect boundingBox = face.boundingBox;
    //
    //   final double? rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
    //   final double? rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees
    //
    //   // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
    //   // eyes, cheeks, and nose available):
    //   final FaceLandmark? leftEar = face.landmarks[FaceLandmarkType.leftEar];
    //   if (leftEar != null) {
    //     final Point<int> leftEarPos = leftEar.position;
    //     print('leftEarPos: $leftEarPos');
    //   }
    //
    //   // If classification was enabled with FaceDetectorOptions:
    //   if (face.smilingProbability != null) {
    //     final double? smileProb = face.smilingProbability;
    //   }
    //
    //   // If face tracking was enabled with FaceDetectorOptions:
    //   if (face.trackingId != null) {
    //     final int id = face.trackingId!;
    //   }
    // }
  }
}
