import 'package:flutter/material.dart';

class CurvedPainter extends CustomPainter {
  CurvedPainter(this.btnSize, this.btnY);

  final double btnSize;
  final double btnY;

  @override
  void paint(Canvas canvas, Size size) {
    var halfBtnSize = btnSize / 2;
    var xMax = size.width;
    var yMax = size.height;

    var path = Path()
      ..moveTo(halfBtnSize, yMax)
      ..lineTo(halfBtnSize, btnY + halfBtnSize * 2)
      ..cubicTo(halfBtnSize, btnY + halfBtnSize, 0, btnY + halfBtnSize, 0, btnY)
      ..cubicTo(0, btnY - halfBtnSize, halfBtnSize, btnY - halfBtnSize,
          halfBtnSize, btnY - halfBtnSize * 2)
      ..lineTo(halfBtnSize, 0)
      ..lineTo(xMax, 0)
      ..lineTo(xMax, yMax);

    canvas.drawPath(
        path,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(CurvedPainter oldDelegate) => oldDelegate.btnY != btnY;
}