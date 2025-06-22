import 'package:assignment_sem6/widgets/view/timeline/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';

class TimelineMinimapPostPainter extends CustomPainter {
  final TimelineController controller;
  final Color timelineColor;

  TimelineMinimapPostPainter(this.controller, {required this.timelineColor});

  @override
  void paint(Canvas canvas, Size size) {
    if (controller.items.isEmpty) {
      return;
    }

    int maxLayer = 0;
    List<TimelineItem> clipped = [];
    for (final item in controller.items) {
      if (item.layer > maxLayer) {
        if (item.layer <= 10) {
          maxLayer = item.layer;
          continue;
        }

        if (controller.visibleEndTimestamp >= item.startTimestamp &&
            controller.visibleStartTimestamp <= item.endTimestamp) {
          maxLayer = item.layer;
          continue;
        }
        clipped.add(item);
      }
    }
    int layersOnBottom = maxLayer ~/ 2;

    final maxHeight = size.height - 6.0;
    final layerHeight = maxHeight / (maxLayer + 1);
    final timelinePosition = maxHeight - (layersOnBottom * layerHeight);

    int spacing = switch (maxLayer) {
      < 4 => layerHeight ~/ 3,
      < 10 => 4,
      >= 10 && < 16 => 2,
      _ => 1,
    };

    final startTimestamp = controller.effectiveStartTimestamp;
    final endTimestamp = controller.effectiveEndTimestamp;

    final totalDuration = (endTimestamp - startTimestamp).toDouble();

    for (final item in controller.items) {
      if (item.layer > maxLayer) {
        continue;
      }

      final startX =
          ((item.startTimestamp - startTimestamp) / totalDuration) * size.width;
      final endX =
          ((item.endTimestamp - startTimestamp) / totalDuration) * size.width;

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
        top = timelinePosition + ((layerOnHalf - 1) * layerHeight) + spacing;
      } else {
        top = timelinePosition - ((layerOnHalf - 0.5) * layerHeight) - spacing;
      }

      canvas.drawRect(
        Rect.fromLTWH(
          startX,
          top,
          endX - startX - spacing,
          layerHeight - spacing,
        ),
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
