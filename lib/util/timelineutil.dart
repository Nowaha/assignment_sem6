import 'dart:math';

import 'package:assignment_sem6/screens/home.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineitem.dart';

class TimelineUtil {
  static final Set<int> _layers = _generateLayers();

  static Set<int> _generateLayers() {
    Set<int> layers = {};
    layers.add(1);
    layers.add(2);
    layers.add(-1);
    // 3, -2, 4, -3, 5, -4, ..., 100, -100
    for (int i = 3; i <= 100; i++) {
      layers.add(i);
      layers.add(-(i - 1));
    }

    return layers;
  }

  static int resolveLayer(TempPost post, List<TimelineItem> previousItems) {
    final occupiedLayers = <int>{};
    for (int i = previousItems.length - 1; i >= 0; i--) {
      final item = previousItems[i];

      if (post.startTimestamp < item.endTimestamp) {
        occupiedLayers.add(item.rawLayer);
      }
    }

    for (final layer in _layers) {
      if (!occupiedLayers.contains(layer)) {
        return layer;
      }
    }

    throw Exception("No available layer found for post: ${post.name}");
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
