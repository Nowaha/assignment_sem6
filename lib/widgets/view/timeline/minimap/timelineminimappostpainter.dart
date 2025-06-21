import 'package:flutter/material.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';

class TimelineMinimapPostPainter extends CustomPainter {
  final TimelineController controller;
  final Color timelineColor;

  TimelineMinimapPostPainter(this.controller, {required this.timelineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final int leeway = controller.leeway;

    if (controller.items.isEmpty) {
      return;
    }

    int maxLayer = controller.items.fold<int>(
      0,
      (max, item) => item.layer > max ? item.layer : max,
    );

    final layerHeight = size.height / (maxLayer + 1);
    final timelinePosition = maxLayer * layerHeight * (2 / 3);

    final totalDuration =
        (controller.endTimestamp - controller.startTimestamp).toDouble();
    final leewayFraction = leeway / totalDuration;

    for (final item in controller.items) {
      final startX =
          ((item.startTimestamp - controller.startTimestamp) / totalDuration +
              leewayFraction) *
          (size.width / (1 + 2 * leewayFraction));
      final endX =
          ((item.endTimestamp - controller.startTimestamp) / totalDuration +
              leewayFraction) *
          (size.width / (1 + 2 * leewayFraction));

      bool isHanging = item.layer > 0 && item.layer % 2 == 0;
      int layerOnHalf;
      if (item.layer == 0) {
        layerOnHalf = 1;
      } else if (item.layer % 2 == 0) {
        layerOnHalf = item.layer ~/ 2;
      } else {
        layerOnHalf = ((item.layer + 1) ~/ 2) + 1;
      }

      double top;
      if (isHanging) {
        top = timelinePosition + ((layerOnHalf - 1) * layerHeight);
      } else {
        top = timelinePosition - (layerOnHalf * layerHeight);
      }

      canvas.drawRect(
        Rect.fromLTWH(startX + 4, top + 4, endX - startX - 4, layerHeight - 4),
        Paint()
          ..color = item.color
          ..style = PaintingStyle.fill,
      );
    }

    if (maxLayer > 1) {
      canvas.drawLine(
        Offset(0, timelinePosition + 1.5),
        Offset(size.width, timelinePosition + 1.5),
        Paint()
          ..color = timelineColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.0,
      );
    }
  }

  @override
  bool shouldRepaint(TimelineMinimapPostPainter oldDelegate) =>
      oldDelegate.controller.items != controller.items;
}
