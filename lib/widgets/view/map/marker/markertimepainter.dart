import 'dart:math';

import 'package:assignment_sem6/extension/canvasextension.dart';
import 'package:assignment_sem6/extension/color.dart';
import 'package:flutter/material.dart';

class MarkerTimePainter extends CustomPainter {
  final Offset offset;
  final int startTimestamp;
  final int endTimestamp;
  final int timelineStartTimestamp;
  final int timelineEndTimestamp;
  final Color color;
  final Color timelineColor;
  final double thickness;

  MarkerTimePainter({
    required this.offset,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.timelineStartTimestamp,
    required this.timelineEndTimestamp,
    required this.color,
    this.timelineColor = Colors.grey,
    this.thickness = 2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final startX = max(
      0.0,
      (startTimestamp - timelineStartTimestamp) /
          (timelineEndTimestamp - timelineStartTimestamp) *
          size.width,
    );
    final endX = min(
      max(
        (endTimestamp - timelineStartTimestamp) /
            (timelineEndTimestamp - timelineStartTimestamp) *
            size.width,
        0.0,
      ),
      size.width,
    );

    bool notOnTimeline = (startX == 0 && endX == 0) || startX > endX;

    canvas.drawLineWithShadow(
      Offset(offset.dx, size.height / 2 + thickness / 2 + offset.dy),
      Offset(
        offset.dx + size.width,
        size.height / 2 + thickness / 2 + offset.dy,
      ),
      Paint()
        ..color = !notOnTimeline ? timelineColor : timelineColor.darken(0.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = thickness / 2,
    );

    if (!notOnTimeline) {
      canvas.drawLine(
        Offset(startX + offset.dx, size.height / 2 + thickness / 2 + offset.dy),
        Offset(endX + offset.dx, size.height / 2 + thickness / 2 + offset.dy),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness,
      );
    }
  }

  @override
  bool shouldRepaint(MarkerTimePainter oldDelegate) =>
      oldDelegate.startTimestamp != startTimestamp ||
      oldDelegate.endTimestamp != endTimestamp ||
      oldDelegate.timelineStartTimestamp != timelineStartTimestamp ||
      oldDelegate.timelineEndTimestamp != timelineEndTimestamp ||
      oldDelegate.color != color ||
      oldDelegate.timelineColor != timelineColor;
}
