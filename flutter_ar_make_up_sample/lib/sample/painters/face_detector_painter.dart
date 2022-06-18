import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'coordinates_translator.dart';

class FaceDetectorPainter extends CustomPainter {
  FaceDetectorPainter(this.faces, this.absoluteImageSize, this.rotation);

  final List<Face> faces;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..color = Colors.red;

    for (final Face face in faces) {
      // 顔毎の四角い枠
      canvas.drawRect(
        Rect.fromLTRB(
          translateX(face.boundingBox.left, rotation, size, absoluteImageSize),
          translateY(face.boundingBox.top, rotation, size, absoluteImageSize),
          translateX(face.boundingBox.right, rotation, size, absoluteImageSize),
          translateY(
              face.boundingBox.bottom, rotation, size, absoluteImageSize),
        ),
        paint,
      );

      void paintContour(FaceContourType type) {
        final faceContour = face.contours[type];
        if (faceContour?.points != null) {
          for (final Point point in faceContour!.points) {
            canvas.drawCircle(
                Offset(
                  translateX(
                      point.x.toDouble(), rotation, size, absoluteImageSize),
                  translateY(
                      point.y.toDouble(), rotation, size, absoluteImageSize),
                ),
                1,
                paint);
          }
        }
      }

      void paintFilledUpperLip() {
        // 上唇のtop輪郭
        final upperLipTopContour = face.contours[FaceContourType.upperLipTop];
        // 上唇のbottom輪郭
        final upperLipBottomContour =
            face.contours[FaceContourType.upperLipBottom];

        if (upperLipTopContour?.points != null &&
            upperLipBottomContour?.points != null) {
          final upperLipTopPath = upperLipTopContour?.points ?? [];
          final upperLipBottomPath = upperLipBottomContour?.points ?? [];
          final upperLipPath = upperLipTopPath + upperLipBottomPath;

          final path = Path();
          path.moveTo(
            translateX(upperLipPath[0].x.toDouble(), rotation, size,
                absoluteImageSize),
            translateY(upperLipPath[0].y.toDouble(), rotation, size,
                absoluteImageSize),
          );

          for (var i = 1; i < upperLipPath.length; i++) {
            path.lineTo(
              translateX(upperLipPath[i].x.toDouble(), rotation, size,
                  absoluteImageSize),
              translateY(upperLipPath[i].y.toDouble(), rotation, size,
                  absoluteImageSize),
            );
          }

          path.close();

          final filledPaint = Paint()..color = Colors.blue;

          canvas.drawPath(path, filledPaint);
        }
      }

      void paintFilledLowerLip() {
        // 下唇のtop輪郭
        final lowerLipTopContour = face.contours[FaceContourType.lowerLipTop];
        // 下唇のbottom輪郭
        final lowerLipBottomContour =
            face.contours[FaceContourType.lowerLipBottom];

        if (lowerLipTopContour?.points != null &&
            lowerLipBottomContour?.points != null) {
          final lowerLipTopPath = lowerLipTopContour?.points ?? [];
          final lowerLipBottomPath = lowerLipBottomContour?.points ?? [];
          final lowerLipPath = lowerLipTopPath + lowerLipBottomPath;

          final path = Path();
          path.moveTo(
            translateX(lowerLipPath[0].x.toDouble(), rotation, size,
                absoluteImageSize),
            translateY(lowerLipPath[0].y.toDouble(), rotation, size,
                absoluteImageSize),
          );

          for (var i = 1; i < lowerLipPath.length; i++) {
            path.lineTo(
              translateX(lowerLipPath[i].x.toDouble(), rotation, size,
                  absoluteImageSize),
              translateY(lowerLipPath[i].y.toDouble(), rotation, size,
                  absoluteImageSize),
            );
          }

          path.close();

          final filledPaint = Paint()..color = Colors.green;

          canvas.drawPath(path, filledPaint);
        }
      }

      paintContour(FaceContourType.face);
      // paintContour(FaceContourType.leftEyebrowTop);
      // paintContour(FaceContourType.leftEyebrowBottom);
      // paintContour(FaceContourType.rightEyebrowTop);
      // paintContour(FaceContourType.rightEyebrowBottom);
      // paintContour(FaceContourType.leftEye);
      // paintContour(FaceContourType.rightEye);
      paintContour(FaceContourType.upperLipTop);
      paintContour(FaceContourType.upperLipBottom);
      paintContour(FaceContourType.lowerLipTop);
      paintContour(FaceContourType.lowerLipBottom);
      // paintContour(FaceContourType.noseBridge);
      // paintContour(FaceContourType.noseBottom);
      // paintContour(FaceContourType.leftCheek);
      // paintContour(FaceContourType.rightCheek);

      paintFilledUpperLip();
      paintFilledLowerLip();
    }
  }

  @override
  bool shouldRepaint(FaceDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.faces != faces;
  }
}
