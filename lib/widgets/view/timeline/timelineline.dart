import 'package:flutter/material.dart';

class TimelineLine extends StatelessWidget {
  static const tickLabelFontSize = 12.0;

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

    String formatTimestamp(int timestamp) {
      final time = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final hours = time.hour.toString().padLeft(2, '0');
      final minutes = time.minute.toString().padLeft(2, '0');
      return '$hours:$minutes';
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: formatTimestamp(firstTickTime),
        style: TextStyle(fontSize: tickLabelFontSize, color: color),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final labelWidth = textPainter.size.width;

    double timeToPosition(int timestamp) {
      final timeDiff = timestamp - centerTime;
      return screenWidth / 2 + (timeDiff / totalVisibleTime) * screenWidth;
    }

    Widget buildTick(int i) {
      final tickTime = firstTickTime + i * tickEvery;
      final position = timeToPosition(tickTime);
      final String timestampLabel = formatTimestamp(tickTime);

      return Positioned(
        left: position - (labelWidth / 2),
        top: 32,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 2,
          children: [
            Container(width: tickWidth, height: 16.0, color: color),
            Text(
              timestampLabel,
              style: TextStyle(
                fontSize: tickLabelFontSize,
                color: color.withAlpha(200),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SizedBox(
      height: 80,
      width: screenWidth,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Container(height: 3, color: color),
            ),
          ),
          for (int i = 0; i <= totalTicks; i++) buildTick(i),
        ],
      ),
    );
  }
}
