import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimappostpainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimapseekerpainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter/material.dart';

class TimelineMiniMap extends StatelessWidget {
  final TimelineController controller;
  final double height;

  const TimelineMiniMap({
    super.key,
    required this.controller,
    this.height = 90.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(126),
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outline,
            width: 2.0,
          ),
        ),
      ),
      child: CustomPaint(
        painter: TimelineMinimapPostPainter(
          controller,
          timelineColor: Theme.of(context).colorScheme.onSurface,
        ),
        foregroundPainter: TimelineMinimapSeekerPainter(controller),
      ),
    );
  }
}
