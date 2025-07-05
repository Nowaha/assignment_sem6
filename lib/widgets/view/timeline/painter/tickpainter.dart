import 'package:assignment_sem6/extension/color.dart';
import 'package:flutter/material.dart';

class TickPainter extends CustomPainter {
  static const tickHeight = 24.0;
  static const tickWidth = 4.0;
  static const tickLabelFontSize = 14.0;

  final int tickTime;
  final int tickEvery;
  final double positionX;
  final double offsetRounded;
  final double centerY;
  final bool isSignificantTick;
  final bool floating;
  final Color timelineColor;
  final Color surfaceColor;
  final Color onSurfaceColor;
  final Color shadowColor;
  final Color ghostColor;
  final bool layerShiftMode;

  const TickPainter({
    required this.tickTime,
    required this.tickEvery,
    required this.positionX,
    required this.offsetRounded,
    required this.centerY,
    required this.isSignificantTick,
    required this.floating,
    required this.timelineColor,
    required this.surfaceColor,
    required this.onSurfaceColor,
    required this.shadowColor,
    required this.ghostColor,
    required this.layerShiftMode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double appliedTickHeight =
        isSignificantTick ? tickHeight : tickHeight * 0.75;
    double appliedTickWidth = isSignificantTick ? tickWidth : tickWidth * 0.8;

    final tickPaint =
        Paint()
          ..color =
              isSignificantTick ? timelineColor : timelineColor.darken(0.4)
          ..strokeWidth = appliedTickWidth
          ..style = PaintingStyle.stroke;

    double tallLineStrokeWidth =
        isSignificantTick ? appliedTickWidth * .9 : appliedTickWidth * .5;
    canvas.drawLine(
      Offset(positionX + appliedTickWidth / 2 - tallLineStrokeWidth * 0.5, 0),
      Offset(
        positionX + appliedTickWidth / 2 - tallLineStrokeWidth,
        size.height,
      ),
      Paint()
        ..color = onSurfaceColor.withAlpha(isSignificantTick ? 40 : 20)
        ..strokeWidth = tallLineStrokeWidth,
    );

    if (floating) {
      canvas.drawLine(
        Offset(
          positionX + appliedTickWidth / 2,
          centerY - appliedTickHeight / 2 + 2,
        ),
        Offset(
          positionX + appliedTickWidth / 2,
          centerY + appliedTickHeight / 2 + 2,
        ),
        Paint()
          ..color = shadowColor
          ..strokeWidth = tickPaint.strokeWidth * 1.25,
      );
    }

    canvas.drawLine(
      Offset(positionX, centerY - appliedTickHeight / 2),
      Offset(positionX, centerY + appliedTickHeight / 2),
      tickPaint,
    );

    // Ghost tick
    if (floating && layerShiftMode) {
      canvas.drawLine(
        Offset(positionX, centerY - offsetRounded - appliedTickHeight / 2),
        Offset(positionX, centerY - offsetRounded + appliedTickHeight / 2),
        Paint()
          ..color = ghostColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = tickPaint.strokeWidth
          ..blendMode = BlendMode.plus,
      );
    }

    _paintLabel(canvas);
  }

  void _paintLabel(Canvas canvas) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: _formatTimestamp(tickTime),
        style: TextStyle(
          color: onSurfaceColor,
          fontSize:
              isSignificantTick ? tickLabelFontSize : tickLabelFontSize * 0.9,
          fontWeight: FontWeight.w500,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    final backgroundRect = Rect.fromLTWH(
      positionX - textPainter.width / 2 - 6,
      centerY + tickHeight - textPainter.height / 2 - 4,
      textPainter.width + 12,
      textPainter.height + 8,
    );

    if (floating) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            backgroundRect.left + 1,
            backgroundRect.top + 1,
            backgroundRect.width + 1,
            backgroundRect.height + 1,
          ),
          Radius.circular(8),
        ),
        Paint()..color = shadowColor,
      );
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(backgroundRect, Radius.circular(8)),
      Paint()..color = surfaceColor,
    );

    final labelX = positionX - textPainter.width / 2;
    final labelY = centerY + tickHeight / 2 + 2;

    textPainter.paint(canvas, Offset(labelX, labelY));
  }

  String _formatTimestamp(int timestamp) {
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
