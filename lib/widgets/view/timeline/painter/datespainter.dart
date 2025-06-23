import 'dart:math';

import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/dashedlinepainter.dart';
import 'package:flutter/material.dart';

typedef CalculationResult =
    ({double startX, double endX, double startY, double endY});
typedef DrawResult = ({double startX, double endX, double startY, double endY});

class DatesPainter extends CustomPainter {
  static const int dayMs = 1000 * 60 * 60 * 24;
  static const edgePadding = 8.0;
  static const textPaddingX = 8.0;
  static const textPaddingY = 6.0;
  static const spaceBetweenDates = 16.0;

  final int startTimestamp;
  final int endTimestamp;
  final int visibleStartTimestamp;
  final int visibleEndTimestamp;
  final int centerTime;
  final int timescale;
  final Color surfaceColor;
  final Color onSurfaceColor;

  DatesPainter({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.visibleStartTimestamp,
    required this.visibleEndTimestamp,
    required this.centerTime,
    required this.timescale,
    required this.surfaceColor,
    required this.onSurfaceColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final date = DateTime.fromMillisecondsSinceEpoch(visibleStartTimestamp);
    final startOfDay = DateTime(date.year, date.month, date.day);
    final startOfVisibleDay = startOfDay.millisecondsSinceEpoch;

    final textPainter = _getDateTextPainter(startOfVisibleDay);

    double startX = 0.0;
    final startY = size.height - textPainter.height - 90;

    int? leftmostX;
    int startOfNextDay = startOfVisibleDay + dayMs;
    while (startOfNextDay >= visibleStartTimestamp &&
        startOfNextDay <= visibleEndTimestamp) {
      final difference = startOfNextDay - visibleStartTimestamp;
      final nextTextPainter = _getDateTextPainter(startOfNextDay);

      nextTextPainter.layout();

      final xBase = (difference / timescale) * size.width;
      final centeredX = xBase - nextTextPainter.width / 2;
      final clampedX = max(xBase, startX);

      final lineX = centeredX + nextTextPainter.width / 2;
      DashedLinePainter(
        x: lineX,
        dashHeight: 4.0,
        dashSpacing: 4.0,
        color: onSurfaceColor.withAlpha(150),
        strokeWidth: 2.0,
      ).paint(canvas, size);

      DrawResult nextDayResult = _calculateAndDrawDate(
        canvas,
        nextTextPainter,
        startOfNextDay,
        clampedX,
        startY,
      );

      if (leftmostX == null || nextDayResult.startX < leftmostX) {
        leftmostX = nextDayResult.startX.toInt();
      }

      startOfNextDay += dayMs;
    }

    final currentDayResult = _calculateDatePosition(
      startX,
      startY,
      textPainter,
    );

    if (leftmostX != null &&
        currentDayResult.endX + spaceBetweenDates >= leftmostX) {
      startX -= (currentDayResult.endX + spaceBetweenDates - leftmostX);

      _calculateAndDrawDate(
        canvas,
        textPainter,
        startOfVisibleDay,
        startX,
        startY,
      );
    } else {
      _drawDate(canvas, textPainter, currentDayResult);
    }
  }

  TextPainter _getDateTextPainter(int timestamp) => TextPainter(
    text: TextSpan(
      text: DateUtil.formatDate(timestamp),
      style: TextStyle(
        color: onSurfaceColor,
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  )..layout();

  CalculationResult _calculateDatePosition(
    double x,
    double y,
    TextPainter textPainter,
  ) {
    final rectX = x + edgePadding;
    final rectHeight = textPainter.height - edgePadding + textPaddingY * 2;
    final rectY = y - rectHeight / 2;
    final rectWidth = textPainter.width + textPaddingX * 2;

    return (
      startX: rectX,
      endX: rectX + rectWidth,
      startY: rectY,
      endY: rectY + rectHeight,
    );
  }

  DrawResult _calculateAndDrawDate(
    Canvas canvas,
    TextPainter textPainter,
    int timestamp,
    double x,
    double y,
  ) {
    return _drawDate(
      canvas,
      textPainter,
      _calculateDatePosition(x, y, textPainter),
    );
  }

  DrawResult _drawDate(
    Canvas canvas,
    TextPainter textPainter,
    CalculationResult calculations,
  ) {
    final rectX = calculations.startX;
    final rectHeight = calculations.endY - calculations.startY;
    final rectY = calculations.startY;
    final rectWidth = calculations.endX - calculations.startX;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(rectX, rectY, rectWidth, rectHeight),
        Radius.circular(8),
      ),
      Paint()
        ..color = surfaceColor
        ..style = PaintingStyle.fill,
    );

    textPainter.paint(
      canvas,
      Offset(
        rectX + (rectWidth - textPainter.width) / 2,
        rectY + (rectHeight - textPainter.height) / 2,
      ),
    );

    return (
      startX: rectX,
      endX: rectX + rectWidth,
      startY: rectY,
      endY: rectY + rectHeight,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
