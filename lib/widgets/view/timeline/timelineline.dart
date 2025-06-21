import 'package:flutter/material.dart';

class TimelineLine extends StatelessWidget {
  final int startTimestamp;
  final int endTimestamp;
  final double timescale;
  final int centerTime;
  final int tickEvery;

  const TimelineLine({
    super.key,
    required this.startTimestamp,
    required this.endTimestamp,
    required this.timescale,
    required this.centerTime,
    required this.tickEvery,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSurface;

    final screenWidth = MediaQuery.of(context).size.width;
    final tickWidth = 4.0;

    final int totalTicks = (timescale / tickEvery).ceil();
    final double totalVisibleTime = timescale;
    final halfVisibleTime = totalVisibleTime / 2;

    int firstTickTime = centerTime - halfVisibleTime.toInt();

    firstTickTime = (firstTickTime ~/ tickEvery) * tickEvery;

    double timeToPosition(int timestamp) {
      final timeDiff = timestamp - centerTime;
      return screenWidth / 2 + (timeDiff / totalVisibleTime) * screenWidth;
    }

    return SizedBox(
      height: 20,
      width: screenWidth,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(height: 3, color: color),
            ),
          ),

          for (int i = 0; i <= totalTicks; i++)
            Positioned(
              left:
                  timeToPosition(firstTickTime + i * tickEvery) - tickWidth / 2,
              child: Container(width: tickWidth, height: 16.0, color: color),
            ),
        ],
      ),
    );
  }
}
