import 'dart:math';

import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final double? x;
  final double? y;
  final double dashHeight;
  final double dashSpacing;
  final Color color;
  final double strokeWidth;

  const DashedLinePainter._({
    this.x,
    this.y,
    required this.dashHeight,
    required this.dashSpacing,
    required this.color,
    this.strokeWidth = 4.0,
  });

  const DashedLinePainter.horizontal({
    required double y,
    required double dashHeight,
    required double dashSpacing,
    required Color color,
    double strokeWidth = 4.0,
  }) : this._(
         x: null,
         y: y,
         dashHeight: dashHeight,
         dashSpacing: dashSpacing,
         color: color,
         strokeWidth: strokeWidth,
       );

  const DashedLinePainter.vertical({
    required double x,
    required double dashHeight,
    required double dashSpacing,
    required Color color,
    double strokeWidth = 4.0,
  }) : this._(
         x: x,
         y: null,
         dashHeight: dashHeight,
         dashSpacing: dashSpacing,
         color: color,
         strokeWidth: strokeWidth,
       );

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth;

    if (x != null) {
      _drawVerticalDashedLine(canvas, size, paint, x!);
    } else if (y != null) {
      _drawHorizontalDashedLine(canvas, size, paint, y!);
    }
  }

  void _drawVerticalDashedLine(
    Canvas canvas,
    Size size,
    Paint paint,
    double x,
  ) {
    double startY = 0;
    while (startY < size.height) {
      canvas.drawLine(
        Offset(x, startY),
        Offset(x, min(startY + dashHeight, size.height)),
        paint,
      );
      startY += dashHeight + dashSpacing;
    }
  }

  void _drawHorizontalDashedLine(
    Canvas canvas,
    Size size,
    Paint paint,
    double y,
  ) {
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, y), Offset(startX + dashHeight, y), paint);
      startX += dashHeight + dashSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
