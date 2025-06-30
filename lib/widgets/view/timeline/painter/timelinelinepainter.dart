import 'package:assignment_sem6/widgets/view/timeline/painter/dashedlinepainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/datespainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/scalepainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/tickpainter.dart';
import 'package:flutter/material.dart' hide Align;
import 'package:assignment_sem6/extension/color.dart';

class TimelinePainter extends CustomPainter {
  static const timelineThickness = 4.0;

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

  @override
  void paint(Canvas canvas, Size size) {
    double offsetAdjusted = offset.abs() < 20 ? 0 : offset;
    bool floating = offsetAdjusted != 0;

    final centerY = size.height / 2;
    final timelineColor = floating ? floatingColor : color;
    final shadowColor = timelineColor.darken(isDarkMode ? 0.7 : 0.5);
    final ghostColor =
        isDarkMode
            ? onSurfaceColor.withAlpha(50)
            : onSurfaceColor.withAlpha(50);

    if (floating) {
      // Ghost dashed line (exact)
      DashedLinePainter.horizontal(
        y: centerY - offsetAdjusted,
        dashHeight: 4.0,
        dashSpacing: 4.0,
        color: ghostColor,
        strokeWidth: 2.0,
      ).paint(canvas, size);

      // Ghost line (rounded)
      canvas.drawLine(
        Offset(0, centerY - offsetRounded),
        Offset(size.width, centerY - offsetRounded),
        Paint()
          ..color = ghostColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = timelineThickness
          ..blendMode = BlendMode.plus,
      );
    }

    // Line shadow
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

      TickPainter(
        tickTime: tickTime,
        tickEvery: tickEvery,
        positionX: positionX,
        offsetRounded: offsetRounded,
        centerY: centerY,
        isSignificantTick: isSignificantTick,
        floating: floating,
        timelineColor: timelineColor,
        surfaceColor: surfaceColor,
        onSurfaceColor: onSurfaceColor,
        shadowColor: shadowColor,
        ghostColor: ghostColor,
      ).paint(canvas, size);
    }

    // The timeline line
    canvas.drawLine(
      Offset(0, centerY),
      Offset(size.width, centerY),
      Paint()
        ..color = timelineColor
        ..strokeWidth = timelineThickness,
    );

    // End / start date & day lines
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

    // Scale on the top right side
    ScalePainter(
      position: Offset(size.width - 80, 40),
      timelineWidth: size.width,
      timelineThickness: timelineThickness,
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
