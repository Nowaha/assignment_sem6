import 'package:assignment_sem6/widgets/view/timeline/timeline.dart';

class TimelineUtil {
  static int resolveLayer(TempPost post, List<TimelineItem> previousItems) {
    final occupiedLayers = <int>{};

    for (int i = previousItems.length - 1; i >= 0; i--) {
      final item = previousItems[i];

      if (post.startTimestamp < item.endTimestamp) {
        occupiedLayers.add(item.layer);
      }
    }

    // Now find the smallest layer that is not occupied
    int layer = 0;
    while (occupiedLayers.contains(layer)) {
      layer++;
    }

    return layer;
  }

  static double getElementLeftPosition(
    double screenWidth,
    int effectiveTimeScale,
    int centerTime,
    TimelineItem item,
    double width,
  ) {
    // Use centerTime as the zero point on the timeline
    final startPosition =
        (item.startTimestamp.toDouble() - centerTime.toDouble()) /
        effectiveTimeScale *
        screenWidth;

    final endPosition =
        (item.endTimestamp.toDouble() - centerTime.toDouble()) /
        effectiveTimeScale *
        screenWidth;

    final leftPosition =
        startPosition + (endPosition - startPosition) / 2 - width / 2;

    return leftPosition + (screenWidth / 2);
  }

  static double getElementWidth(
    double screenWidth,
    int effectiveTimeScale,
    int startTimestamp,
    int endTimestamp,
  ) {
    return (endTimestamp.toDouble() - startTimestamp.toDouble()) /
        effectiveTimeScale *
        screenWidth;
  }

  static int calculateTickEvery(int timescale, int pixelWidth) {
    const idealPixelPerTick = 120;
    int targetTicks = (pixelWidth / idealPixelPerTick).round();
    return _roundToNiceInterval(timescale ~/ targetTicks);
  }

  static int _roundToNiceInterval(int intervalMs) {
    const niceValues = [
      100,
      200,
      500,
      1000,
      2000,
      5000,
      10000,
      15000,
      30000,
      60000,
      120000,
      300000,
      600000,
      1800000,
      3600000,
    ];

    for (final value in niceValues) {
      if (intervalMs <= value) return value;
    }

    return intervalMs; // fallback
  }
}
