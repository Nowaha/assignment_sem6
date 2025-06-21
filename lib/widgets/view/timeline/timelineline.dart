import 'package:assignment_sem6/widgets/view/timeline/timelinelinepainter.dart';
import 'package:flutter/material.dart';

class TimelineLine extends StatelessWidget {
  final int startTimestamp;
  final int endTimestamp;
  final int tickEvery;
  final int timescale;
  final int centerTime;

  const TimelineLine({
    super.key,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.tickEvery,
    required this.timescale,
    required this.centerTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final halfVisibleTime = timescale / 2;

    int firstTickTime = centerTime - halfVisibleTime.toInt();

    firstTickTime = (firstTickTime ~/ tickEvery) * tickEvery;

    return RepaintBoundary(
      child: IgnorePointer(
        child: SizedBox(
          height: 80,
          width: double.infinity,
          child: CustomPaint(
            painter: TimelinePainter(
              centerTime: centerTime,
              timescale: timescale,
              tickEvery: tickEvery,
              totalTicks: (timescale / tickEvery).ceil(),
              firstTickTime:
                  (centerTime - timescale / 2).toInt() ~/ tickEvery * tickEvery,
              color: theme.colorScheme.onSurface,
              surfaceColor: theme.colorScheme.surface,
              onSurfaceColor: theme.colorScheme.onSurface,
              screenWidth: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}
