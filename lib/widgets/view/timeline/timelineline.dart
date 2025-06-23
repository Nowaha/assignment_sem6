import 'package:assignment_sem6/widgets/view/timeline/painter/timelinelinepainter.dart';
import 'package:flutter/material.dart';

class TimelineLine extends StatelessWidget {
  final int startTimestamp;
  final int endTimestamp;
  final int visibleStartTimestamp;
  final int visibleEndTimestamp;
  final int tickEvery;
  final int timescale;
  final int centerTime;
  final Color color;
  final double offset;
  final double offsetRounded;

  const TimelineLine({
    super.key,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.visibleStartTimestamp,
    required this.visibleEndTimestamp,
    required this.tickEvery,
    required this.timescale,
    required this.centerTime,
    this.color = Colors.white,
    this.offset = 0.0,
    this.offsetRounded = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final halfVisibleTime = timescale / 2;

    int firstTickTime = centerTime - halfVisibleTime.toInt();

    firstTickTime = (firstTickTime ~/ tickEvery) * tickEvery;

    bool isDarkMode = theme.brightness == Brightness.dark;

    Color floatingColor;
    if (isDarkMode) {
      floatingColor = theme.colorScheme.primary;
    } else {
      floatingColor = Colors.white;
    }

    return RepaintBoundary(
      child: IgnorePointer(
        child: CustomPaint(
          painter: TimelinePainter(
            startTimestamp: startTimestamp,
            endTimestamp: endTimestamp,
            visibleStartTimestamp: visibleStartTimestamp,
            visibleEndTimestamp: visibleEndTimestamp,
            centerTime: centerTime,
            timescale: timescale,
            tickEvery: tickEvery,
            totalTicks: (timescale / tickEvery).ceil(),
            firstTickTime:
                (centerTime - timescale / 2).toInt() ~/ tickEvery * tickEvery,
            color: color,
            floatingColor: floatingColor,
            surfaceColor: theme.colorScheme.surface,
            onSurfaceColor: theme.colorScheme.onSurface,
            screenWidth: MediaQuery.of(context).size.width,
            isDarkMode: isDarkMode,
            offset: offset,
            offsetRounded: offsetRounded,
          ),
        ),
      ),
    );
  }
}
