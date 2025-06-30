import 'dart:math';

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
    final timelinePaint =
        Paint()
          ..color = timelineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness / 2;

    final itemPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = thickness;

    canvas.drawLine(
      Offset(offset.dx, size.height / 2 + thickness / 2 + offset.dy),
      Offset(offset.dx + size.width, size.height / 2 + thickness / 2 + offset.dy),
      timelinePaint,
    );

    final startX = max(
      0.0,
      (startTimestamp - timelineStartTimestamp) /
          (timelineEndTimestamp - timelineStartTimestamp) *
          size.width,
    );
    final endX = min(
      (endTimestamp - timelineStartTimestamp) /
          (timelineEndTimestamp - timelineStartTimestamp) *
          size.width,
      size.width,
    );

    canvas.drawLine(
      Offset(startX + offset.dx, size.height / 2 + thickness / 2 + offset.dy),
      Offset(endX + offset.dx, size.height / 2 + thickness / 2 + offset.dy),
      itemPaint,
    );
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
