import 'package:flutter/material.dart';

/// 三角形を描画するPainter
class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // 背景
    final bgPaint = Paint()..color = Colors.blue;
    final bgRect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawRect(bgRect, bgPaint);

    // 三角形（塗りつぶし）
    final filledTrianglePaint = Paint()..color = Colors.purpleAccent;
    final filledTrianglePath = Path();
    // 三角形の頂点から左回りでPathを生成
    filledTrianglePath.moveTo(size.width/2, size.height/5); // 始点
    filledTrianglePath.lineTo(size.width/4, size.height/5*2);
    filledTrianglePath.lineTo(size.width/4*3, size.height/5*2);
    filledTrianglePath.close();
    // 描画
    canvas.drawPath(filledTrianglePath, filledTrianglePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
