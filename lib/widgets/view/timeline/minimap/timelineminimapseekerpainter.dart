import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter/material.dart';

class TimelineMinimapSeekerPainter extends CustomPainter {
  final TimelineController controller;

  TimelineMinimapSeekerPainter(this.controller);

  @override
  void paint(Canvas canvas, Size size) {
    if (controller.visibleStartTimestamp == controller.visibleEndTimestamp) {
      return;
    }

    final seekerStart =
        (controller.visibleStartTimestamp - controller.startTimestamp) /
        (controller.endTimestamp - controller.startTimestamp) *
        size.width;
    final seekerEnd =
        (controller.visibleEndTimestamp - controller.startTimestamp) /
        (controller.endTimestamp - controller.startTimestamp) *
        size.width;

    final emptySpacePaint =
        Paint()
          ..color = Colors.black.withAlpha(150)
          ..style = PaintingStyle.fill;

    final handleBarPaint =
        Paint()
          ..color = const Color.fromARGB(255, 204, 204, 204)
          ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, seekerStart, size.height),
      emptySpacePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(seekerStart, -8, 4, size.height + 8),
      handleBarPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(seekerEnd, 0, size.width - seekerEnd, size.height),
      emptySpacePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(seekerEnd - 4, -8, 4, size.height + 8),
      handleBarPaint,
    );
  }

  @override
  bool shouldRepaint(TimelineMinimapSeekerPainter oldDelegate) =>
      oldDelegate.controller.visibleCenterTimestamp !=
      controller.visibleCenterTimestamp;
}
