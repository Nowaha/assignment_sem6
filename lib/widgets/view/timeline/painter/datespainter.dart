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

    final textPainter = _getDateTextPainter(visibleStartTimestamp);

    double startX = 0.0;
    final startY = size.height - textPainter.height - edgePadding;

    final endTextPainter = _getDateTextPainter(
      visibleEndTimestamp,
      textAlign: TextAlign.right,
    );
    final endDayCalc = _calculateDatePosition(
      size.width,
      startY,
      endTextPainter,
      fromRight: true,
    );

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
      DashedLinePainter.vertical(
        x: lineX,
        dashHeight: 4.0,
        dashSpacing: 4.0,
        color: onSurfaceColor.withAlpha(150),
        strokeWidth: 2.0,
      ).paint(canvas, size);

      CalculationResult nextDayCalc = _calculateDatePosition(
        clampedX,
        startY,
        nextTextPainter,
      );

      const animated = 16;
      final yOffsetIfNeeded = nextDayCalc.startY - nextDayCalc.endY;
      double yOffset = 0.0;
      if (nextDayCalc.endX > endDayCalc.startX) {
        yOffset = yOffsetIfNeeded;
      } else if (nextDayCalc.endX + animated > endDayCalc.startX) {
        final progress = nextDayCalc.endX + animated - endDayCalc.startX;
        yOffset = yOffsetIfNeeded * (progress / animated);
      }

      DrawResult nextDayResult = _calculateAndDrawDate(
        canvas,
        nextTextPainter,
        clampedX,
        startY + yOffset,
      );

      if (leftmostX == null || nextDayResult.startX < leftmostX) {
        leftmostX = nextDayResult.startX.toInt();
      }

      startOfNextDay += dayMs;
    }

    final currentDayCalc = _calculateDatePosition(startX, startY, textPainter);

    if (leftmostX != null &&
        currentDayCalc.endX + spaceBetweenDates >= leftmostX) {
      startX -= (currentDayCalc.endX + spaceBetweenDates - leftmostX);

      _calculateAndDrawDate(canvas, textPainter, startX, startY);
    } else {
      _drawDate(canvas, textPainter, currentDayCalc);
    }

    _drawDate(canvas, endTextPainter, endDayCalc);
  }

  TextPainter _getDateTextPainter(
    int timestamp, {
    TextAlign textAlign = TextAlign.left,
  }) => TextPainter(
    text: TextSpan(
      text:
          "${DateUtil.formatTime(timestamp, true)}\n${DateUtil.formatDate(timestamp)}",
      style: TextStyle(
        color: onSurfaceColor,
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    textAlign: textAlign,
    textDirection: TextDirection.ltr,
  )..layout();

  CalculationResult _calculateDatePosition(
    double x,
    double y,
    TextPainter textPainter, {
    bool fromRight = false,
    bool fromBottom = true,
  }) {
    final rectX;
    final rectY;
    final rectWidth = textPainter.width + textPaddingX * 2;
    final rectHeight = textPainter.height + textPaddingY * 2;

    if (!fromRight) {
      rectX = x + edgePadding;
    } else {
      rectX = x - edgePadding - textPainter.width - textPaddingX * 2;
    }

    if (fromBottom) {
      rectY = y - edgePadding;
    } else {
      rectY = y + edgePadding + textPainter.height + textPaddingY * 2;
    }

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
