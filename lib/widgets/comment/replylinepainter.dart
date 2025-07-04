import 'package:flutter/material.dart';

class ReplyLinePainter extends CustomPainter {
  static const width = 2.0;
  static const connectingLineDistance = 44.0;

  final Color color;
  final bool anotherReplyBelow;
  final bool connectingOnly;

  ReplyLinePainter({
    required this.color,
    required this.anotherReplyBelow,
    this.connectingOnly = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = width;

    if (!connectingOnly) {
      canvas.drawLine(
        Offset(size.width / 2, 0),
        Offset(size.width / 2, connectingLineDistance),
        paint,
      );

      if (anotherReplyBelow) {
        canvas.drawLine(
          Offset(size.width / 2, connectingLineDistance),
          Offset(size.width / 2, size.height),
          paint,
        );
      }
    }

    canvas.drawLine(
      Offset(0, connectingLineDistance),
      Offset(22, connectingLineDistance),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
