import 'package:assignment_sem6/widgets/view/timeline/painter/dashedlinepainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/datespainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/scalepainter.dart';
import 'package:flutter/material.dart' hide Align;
import 'package:assignment_sem6/extension/color.dart';

class TimelinePainter extends CustomPainter {
  static const timelineThickness = 4.0;
  static const tickHeight = 24.0;
  static const tickWidth = 4.0;
  static const tickLabelFontSize = 14.0;

  final int startTimestamp;
  final int endTimestamp;
  final int visibleStartTimestamp;
  final int visibleEndTimestamp;
  final int centerTime;
  final int timeScale;
  final int tickEvery;
  final int totalTicks;
  final int firstTickTime;
  final double offset;
  final double offsetRounded;
  final Color color;
  final Color floatingColor;
  final Color onSurfaceColor;
  final Color surfaceColor;
  final double screenWidth;
  final bool isDarkMode;

  TimelinePainter({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.visibleStartTimestamp,
    required this.visibleEndTimestamp,
    required this.centerTime,
    required this.timeScale,
    required this.tickEvery,
    required this.totalTicks,
    required this.firstTickTime,
    required this.color,
    required this.floatingColor,
    required this.onSurfaceColor,
    required this.surfaceColor,
    required this.screenWidth,
    required this.isDarkMode,
    this.offset = 0.0,
    this.offsetRounded = 0.0,
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
    double offsetAdjusted = offset.abs() < 20 ? 0 : offset;
    bool floating = offsetAdjusted != 0;

    final centerY = size.height / 2;
    final timelineColor = floating ? floatingColor : color;
    final shadowColor = timelineColor.darken(isDarkMode ? 0.7 : 0.5);
    final ghostColor =
        isDarkMode
            ? onSurfaceColor.withAlpha(25)
            : onSurfaceColor.withAlpha(50);

    if (floating) {
      DashedLinePainter.horizontal(
        y: centerY - offsetAdjusted,
        dashHeight: 4.0,
        dashSpacing: 4.0,
        color: ghostColor,
        strokeWidth: 2.0,
      ).paint(canvas, size);

      canvas.drawLine(
        Offset(0, centerY - offsetRounded),
        Offset(size.width, centerY - offsetRounded),
        Paint()
          ..color = ghostColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = timelineThickness,
      );
    }

    final paint =
        Paint()
          ..color = timelineColor
          ..strokeWidth = timelineThickness;

    if (floating) {
      canvas.drawLine(
        Offset(0, centerY + 4),
        Offset(size.width, centerY + 4),
        Paint()
          ..color = shadowColor
          ..strokeWidth = timelineThickness,
      );
    }

    for (int i = 0; i <= totalTicks; i++) {
      final tickTime = firstTickTime + i * tickEvery;
      final timeDiff = tickTime - centerTime;
      final positionX = size.width / 2 + (timeDiff / timeScale) * size.width;

      if (positionX < 0 || positionX > size.width) continue;

      bool isSignificantTick = tickTime % (tickEvery * 5) == 0;
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

      if (floating) {
        canvas.drawLine(
          Offset(positionX, centerY - offsetRounded - appliedTickHeight / 2),
          Offset(positionX, centerY - offsetRounded + appliedTickHeight / 2),
          Paint()
            ..color = ghostColor
            ..style = PaintingStyle.stroke
            ..strokeWidth = tickPaint.strokeWidth,
        );
      }

      final textPainter = TextPainter(
        text: TextSpan(
          text: formatTimestamp(tickTime),
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

    canvas.drawLine(Offset(0, centerY), Offset(size.width, centerY), paint);

    DatesPainter(
      startTimestamp: visibleStartTimestamp,
      endTimestamp: visibleEndTimestamp,
      visibleStartTimestamp: visibleStartTimestamp,
      visibleEndTimestamp: visibleEndTimestamp,
      centerTime: centerTime,
      timescale: timeScale,
      surfaceColor: surfaceColor,
      onSurfaceColor: onSurfaceColor,
    ).paint(canvas, size);

    ScalePainter(
      position: Offset(size.width - 100, 50),
      timelineWidth: size.width,
      timelineThickness: timelineThickness,
      tickHeight: tickHeight,
      tickWidth: tickWidth,
      scaleDownFactor: .8,
      timeScale: timeScale,
      tickEvery: tickEvery,
      visibleStartTimestamp: visibleStartTimestamp,
      timelineColor: color,
      surfaceColor: surfaceColor,
      align: Align.right,
    ).paint(canvas, Size(100, 100));
  }

  @override
  bool shouldRepaint(covariant TimelinePainter oldDelegate) {
    return oldDelegate.centerTime != centerTime ||
        oldDelegate.timeScale != timeScale ||
        oldDelegate.tickEvery != tickEvery ||
        oldDelegate.surfaceColor != surfaceColor ||
        oldDelegate.color != color ||
        oldDelegate.offset != offset;
  }
}
