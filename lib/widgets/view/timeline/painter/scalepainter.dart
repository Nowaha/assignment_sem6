import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/tickpainter.dart';
import 'package:flutter/material.dart';

class ScalePainter extends CustomPainter {
  static const padding = 8.0;
  static const textPadding = 8.0;

  final Offset position;
  final double timelineWidth;
  final num timelineThickness;
  final double tickHeight;
  final double tickWidth;
  final int timeScale;
  final int tickEvery;
  final int visibleStartTimestamp;
  final Color timelineColor;
  final Color surfaceColor;
  final Align align;

  ScalePainter({
    required this.position,
    required this.timelineWidth,
    required timelineThickness,
    required scaleDownFactor,
    required this.timeScale,
    required this.tickEvery,
    required this.visibleStartTimestamp,
    required this.timelineColor,
    required this.surfaceColor,
    this.align = Align.center,
  }) : timelineThickness = timelineThickness * scaleDownFactor,
       tickHeight = TickPainter.tickHeight * scaleDownFactor,
       tickWidth = TickPainter.tickWidth * scaleDownFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = timelineColor
          ..strokeWidth = timelineThickness.toDouble();

    final width = (timelineWidth / timeScale * tickEvery);
    final double startX, endX;
    switch (align) {
      case Align.left:
        startX = position.dx;
        endX = startX + width;
        break;
      case Align.center:
        startX = position.dx - width / 2;
        endX = startX + width;
        break;
      case Align.right:
        startX = position.dx - width;
        endX = startX + width;
        break;
    }
    final double centerX = (startX + endX) / 2;

    final double height = tickHeight + padding * 2;
    final double startY = position.dy - height / 2;
    final double centerY = startY + tickHeight / 2 + padding;
    final double scaleY = startY + tickHeight / 2 + padding;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(startX - padding, startY, width + 2 * padding, height),
        Radius.circular(4),
      ),
      Paint()
        ..color = surfaceColor.withAlpha(150)
        ..style = PaintingStyle.fill,
    );

    final textPainter = TextPainter(
      text: TextSpan(
        text: TimelineUtil.formatInterval(tickEvery),
        style: TextStyle(color: timelineColor, fontSize: 12),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final textOffset = Offset(
      centerX - textPainter.width / 2,
      centerY - textPainter.height / 2,
    );
    textPainter.paint(canvas, textOffset);

    canvas.drawLine(
      Offset(startX, scaleY),
      Offset(textOffset.dx - textPadding, scaleY),
      paint,
    );
    canvas.drawLine(
      Offset(textOffset.dx + textPainter.width + textPadding, scaleY),
      Offset(endX, scaleY),
      paint,
    );

    final tickPaint =
        Paint()
          ..color = timelineColor
          ..strokeWidth = tickWidth;

    canvas.drawLine(
      Offset(startX, scaleY - tickHeight / 2),
      Offset(startX, scaleY + tickHeight / 2),
      tickPaint,
    );

    canvas.drawLine(
      Offset(endX, scaleY - tickHeight / 2),
      Offset(endX, scaleY + tickHeight / 2),
      tickPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum Align { left, center, right }
