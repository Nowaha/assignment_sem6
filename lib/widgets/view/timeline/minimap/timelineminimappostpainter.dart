import 'dart:math';

import 'package:assignment_sem6/widgets/view/timeline/timelineitem.dart';
import 'package:flutter/material.dart';

class TimelineMinimapPostPainter extends CustomPainter {
  static const double timelineThickness = 2.0;

  final List<TimelineItem> items;
  final int startTimestamp;
  final int endTimestamp;
  final Color timelineColor;

  TimelineMinimapPostPainter({
    required this.items,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.timelineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    int maxLayer = 0;
    int minLayer = 0;
    for (final item in items) {
      if (item.rawLayer > maxLayer) {
        maxLayer = item.rawLayer;
      } else if (item.rawLayer < minLayer) {
        minLayer = item.rawLayer;
      }
    }

    if (items.isEmpty) {
      canvas.drawLine(
        Offset(0, size.height / 2 + timelineThickness / 2),
        Offset(size.width, size.height / 2 + timelineThickness / 2),
        Paint()
          ..color = timelineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = timelineThickness,
      );
      return;
    }

    final totalLayers = maxLayer.abs() + minLayer.abs();

    if (maxLayer == 0) return;

    final maxHeight = size.height - 6.0;
    final layerHeight = maxHeight / totalLayers;
    final timelinePosition = maxHeight - (minLayer.abs() * layerHeight);

    int spacing = switch (totalLayers) {
      < 4 => layerHeight ~/ 3,
      < 10 => 4,
      >= 10 && < 16 => 2,
      _ => 1,
    };

    final totalDuration = (endTimestamp - startTimestamp).toDouble();

    for (final item in items) {
      final startX = max(
        0.0,
        ((item.startTimestamp + 1000 * 60 - startTimestamp) / totalDuration) *
            size.width,
      );
      final endX = min(
        size.width,
        ((item.endTimestamp - 1000 * 60 - startTimestamp) / totalDuration) *
            size.width,
      );

      final isHanging = item.rawLayer < 0;
      final layer = item.rawLayer.abs();

      double top;
      if (isHanging) {
        top = timelinePosition + ((layer - 1) * layerHeight) + spacing;
      } else {
        top =
            timelinePosition -
            ((layer - 0.5) * layerHeight) -
            spacing -
            timelineThickness;
      }

      canvas.drawRect(
        Rect.fromLTWH(startX, top, endX - startX, layerHeight - spacing),
        Paint()
          ..color = item.color
          ..style = PaintingStyle.fill,
      );
    }

    canvas.drawLine(
      Offset(0, timelinePosition + timelineThickness / 2),
      Offset(size.width, timelinePosition + timelineThickness / 2),
      Paint()
        ..color = timelineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = timelineThickness,
    );
  }

  @override
  bool shouldRepaint(TimelineMinimapPostPainter oldDelegate) =>
      oldDelegate.items != items ||
      oldDelegate.startTimestamp != startTimestamp ||
      oldDelegate.endTimestamp != endTimestamp ||
      oldDelegate.timelineColor != timelineColor;
}
