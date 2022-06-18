import 'package:flutter/material.dart';
import 'package:flutter_ar_make_up_sample/sample/painters/practice/circle_painter.dart';

/// CustomPainterを自作して円を描画する
class CirclePaintPage extends StatelessWidget {
  const CirclePaintPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: CirclePainter(),
        child: Container(
          height: 500,
        ),
      ),
    );
  }
}
