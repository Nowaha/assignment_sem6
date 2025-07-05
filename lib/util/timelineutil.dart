import 'package:assignment_sem6/data/entity/impl/post.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';

class TimelineUtil {
  static final Set<int> _layers = _generateLayers();

  static Set<int> _generateLayers() {
    Set<int> layers = {};
    layers.add(1);
    layers.add(2);
    layers.add(-1);
    // 3, -2, 4, -3, 5, -4, ..., 100, -99
    for (int i = 3; i <= 100; i++) {
      layers.add(i);
      layers.add(-(i - 1));
    }

    return layers;
  }

  static int resolveLayer(
    int startTimestamp,
    List<TimelineItem> previousItems,
  ) {
    final occupiedLayers = <int>{};
    for (int i = previousItems.length - 1; i >= 0; i--) {
      final item = previousItems[i];

      if (startTimestamp < item.endTimestamp) {
        occupiedLayers.add(item.rawLayer);
      }
    }

    for (final layer in _layers) {
      if (!occupiedLayers.contains(layer)) {
        return layer;
      }
    }

    throw Exception("No available layer found.");
  }

  static Color resolveColor(Post post) {
    final timestamp = post.startTimestamp;
    return Colors.primaries[((timestamp >> 5) ^ timestamp) %
        Colors.primaries.length];
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

  static const niceValues = [
    1000, // 1 second
    2000, // 2 seconds
    5000, // 5 seconds
    10000, // 10 seconds
    15000, // 15 seconds
    30000, // 30 seconds
    60000, // 1 minute
    120000, // 2 minutes
    300000, // 5 minutes
    600000, // 10 minutes
    1800000, // 30 minutes
    3600000, // 1 hour
    7200000, // 2 hours
    14400000, // 4 hours
    21600000, // 6 hours
    43200000, // 12 hours
    86400000, // 1 day
  ];

  static int _roundToNiceInterval(int intervalMs) {
    for (final value in niceValues) {
      if (intervalMs <= value) return value;
    }

    return intervalMs; // fallback
  }

  static double calculateLayerOffset(
    double verticalOffset,
    double itemHeight,
    int divisor,
  ) {
    if (divisor == 1) {
      return -(verticalOffset / itemHeight).roundToDouble();
    }
    return -((verticalOffset / itemHeight) * divisor).roundToDouble() / divisor;
  }

  static int preferredExpansion(int visibleTimeFrame) =>
      (visibleTimeFrame.toDouble() / (1000 * 60)).ceil() * (1000 * 60);

  static int calculateInitialTimeScale(int startTimestamp, int endTimestamp) {
    final duration = endTimestamp - startTimestamp;
    return (duration ~/ 4).clamp(1000 * 60, 1000 * 60 * 60 * 24);
  }
}
