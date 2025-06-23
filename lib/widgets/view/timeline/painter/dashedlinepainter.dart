import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  final double x;
  final double dashHeight;
  final double dashSpacing;
  final Color color;
  final double strokeWidth;

  DashedLinePainter({
    required this.x,
    required this.dashHeight,
    required this.dashSpacing,
    required this.color,
    this.strokeWidth = 4.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth;

    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(x, y), Offset(x, y + dashHeight), paint);
      y += dashHeight + dashSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
