import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';

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
    7200000,
    14400000,
  ];

  static int _roundToNiceInterval(int intervalMs) {
    for (final value in niceValues) {
      if (intervalMs <= value) return value;
    }

    return intervalMs; // fallback
  }

  static String formatInterval(int intervalMs) {
    final seconds = (intervalMs / 1000).floor();
    final minutes = (seconds / 60).floor();
    final hours = (minutes / 60).floor();

    String result = "";
    if (hours > 0) {
      result += '${hours}h ';
    }
    if (minutes % 60 > 0) {
      result += '${minutes % 60}m ';
    }
    if (seconds % 60 > 0) {
      result += '${seconds % 60}s';
    }
    if (result.isEmpty) {
      result = '0s';
    }
    return result.trim();
  }
}
