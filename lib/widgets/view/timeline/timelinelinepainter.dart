import 'package:flutter/material.dart';

class TimelinePainter extends CustomPainter {
  static const timelineThickness = 6.0;
  static const tickHeight = 24.0;
  static const tickWidth = 5.0;
  static const tickLabelFontSize = 14.0;

  final int centerTime;
  final int timescale;
  final int tickEvery;
  final int totalTicks;
  final int firstTickTime;
  final Color color;
  final Color onSurfaceColor;
  final Color surfaceColor;
  final double screenWidth;

  TimelinePainter({
    required this.centerTime,
    required this.timescale,
    required this.tickEvery,
    required this.totalTicks,
    required this.firstTickTime,
    required this.color,
    required this.onSurfaceColor,
    required this.surfaceColor,
    required this.screenWidth,
  });

  String formatTimestamp(int timestamp) {
    final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');

    if (tickEvery >= 1000 * 60) {
      return '$hours:$minutes';
    }

    final seconds = time.second.toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = timelineThickness;

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

      final textPainter = TextPainter(
        text: TextSpan(
          text: formatTimestamp(tickTime),
          style: TextStyle(color: onSurfaceColor, fontSize: tickLabelFontSize),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final backgroundRect = Rect.fromLTWH(
        positionX - textPainter.width / 2 - 4,
        centerY + tickHeight - textPainter.height / 2 - 4,
        textPainter.width + 8,
        textPainter.height + 8,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(backgroundRect, Radius.circular(8)),
        Paint()..color = surfaceColor,
      );

      final labelX = positionX - textPainter.width / 2;
      final labelY = centerY + tickHeight / 2 + 3;

      textPainter.paint(canvas, Offset(labelX, labelY));

      canvas.drawLine(
        Offset(positionX, centerY - tickHeight / 2),
        Offset(positionX, centerY + tickHeight / 2),
        tickPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TimelinePainter oldDelegate) {
    return oldDelegate.centerTime != centerTime ||
        oldDelegate.timescale != timescale ||
        oldDelegate.tickEvery != tickEvery;
  }
}
