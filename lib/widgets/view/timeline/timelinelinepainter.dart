import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
  static const tickHeight = 16.0;
  static const tickWidth = 3.0;
  static const tickLabelFontSize = 12.0;

  final int centerTime;
  final double timescale;
  final int tickEvery;
  final int totalTicks;
  final int firstTickTime;
  final Color color;
  final double screenWidth;

  TimelinePainter({
    required this.centerTime,
    required this.timescale,
    required this.tickEvery,
    required this.totalTicks,
    required this.firstTickTime,
    required this.color,
    required this.screenWidth,
  });

  String formatTimestamp(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 3;

    final centerY = size.height / 2;
    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), paint);

    final tickPaint =
        Paint()
          ..color = color
          ..strokeWidth = tickWidth;

    for (int i = 0; i <= totalTicks; i++) {
      final tickTime = firstTickTime + i * tickEvery;
      final timeDiff = tickTime - centerTime;
      final positionX = size.width / 2 + (timeDiff / timescale) * size.width;

      if (positionX < 0 || positionX > size.width) continue;

      final tickHeight = 16.0;
      canvas.drawLine(
        Offset(positionX, centerY - tickHeight / 2),
        Offset(positionX, centerY + tickHeight / 2),
        tickPaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: formatTimestamp(tickTime),
          style: TextStyle(color: color, fontSize: tickLabelFontSize),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelX = positionX - textPainter.width / 2;
      final labelY = centerY + tickHeight / 2 + 2;

      textPainter.paint(canvas, Offset(labelX, labelY));
    }
  }

  @override
  bool shouldRepaint(covariant TimelinePainter oldDelegate) {
    return oldDelegate.centerTime != centerTime ||
        oldDelegate.timescale != timescale ||
        oldDelegate.tickEvery != tickEvery;
  }
}
