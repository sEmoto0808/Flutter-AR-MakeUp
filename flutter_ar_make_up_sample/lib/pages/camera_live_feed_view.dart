import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import '../utils/camera_helper.dart';

class CameraLiveFeedView extends StatefulWidget {
  final CameraDescription camera;
  final Function(InputImage inputImage) onImage;
  final CustomPaint? customPaint;

  const CameraLiveFeedView({
    Key? key,
    required this.camera,
    required this.onImage, this.customPaint,
  }) : super(key: key);

  @override
  State<CameraLiveFeedView> createState() => _CameraLiveFeedViewState();
}

class _CameraLiveFeedViewState extends State<CameraLiveFeedView> {
  late final CameraController _controller;

  @override
  void initState() {
    _controller = CameraController(widget.camera, ResolutionPreset.max);
    _controller.initialize().then(
          (value) {
        if (!mounted) {
          return;
        }
        _startLiveFeed();
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

    super.initState();
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _liveFeedBody();
  }

  Widget _liveFeedBody() {
    if (_controller.value.isInitialized == false) {
      return Container();
    }

    final size = MediaQuery
        .of(context)
        .size;
    var scale = size.aspectRatio * _controller.value.aspectRatio;
    if (scale < 1) scale = 1 / scale;

    return Stack(
      fit: StackFit.expand,
      children: [
        Transform.scale(
          scale: scale,
          child: CameraPreview(_controller),
        ),
        if (widget.customPaint != null) widget.customPaint!
      ],
    );
  }

  void _startLiveFeed() {
    _controller.startImageStream(_processImage);
  }

  Future _stopLiveFeed() async {
    await _controller.stopImageStream();
    await _controller.dispose();
  }

  Future<void> _processImage(CameraImage image) async {
    // convert CameraImage -> Uint8List
    final imageBytes = concatenatePlanes(image.planes);
    final inputImage = InputImage.fromBytes(
      bytes: imageBytes,
      inputImageData: buildImageData(
        image,
        rotationIntToImageRotation(widget.camera.sensorOrientation),
      ),
    );

    widget.onImage(inputImage);
  }
}
