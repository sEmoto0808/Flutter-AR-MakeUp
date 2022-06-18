import 'package:flutter/material.dart';

/// 円を描画するPainter
/// 図形データを与えて、Canvas上に描写する
class CirclePainter extends CustomPainter {
  /// 必須
  @override
  void paint(Canvas canvas, Size size) {
    // 背景
    final bgPaint = Paint()..color = Colors.yellow;
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(bgRect, bgPaint);

    // 円（塗りつぶし）
    final filledCirclePaint = Paint()..color = Colors.green;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 4),
      size.width / 4,
      filledCirclePaint,
    );

    // 円（枠線）
    final outlinedCirclePainter = Paint()
      ..color = Colors.red
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 4 * 3),
      size.width / 4,
      outlinedCirclePainter,
    );
  }

  /// 必須
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
