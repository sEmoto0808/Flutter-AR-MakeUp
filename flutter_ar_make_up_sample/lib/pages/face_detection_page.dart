import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// カメラを起動して顔検出する画面
class FaceDetectionPage extends StatefulWidget {
  final CameraDescription camera;

  const FaceDetectionPage({Key? key, required this.camera}) : super(key: key);

  @override
  State<FaceDetectionPage> createState() => _FaceDetectionPageState();
}

class _FaceDetectionPageState extends State<FaceDetectionPage> {
  late final CameraController _controller;

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

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
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
    print('CameraImage: $image');
  }
}
