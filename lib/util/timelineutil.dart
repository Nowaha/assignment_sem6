import 'package:assignment_sem6/widgets/view/timeline/timeline.dart';

class TimelineUtil {
  static int resolveLayer(TempPost post, List<TimelineItem> previousItems) {
    final occupiedLayers = <int>{};

    for (int i = previousItems.length - 1; i >= 0; i--) {
      final item = previousItems[i];

      if (item.endTimestamp <= post.startTimestamp) break;

      if (!(post.endTimestamp <= item.startTimestamp ||
          post.startTimestamp >= item.endTimestamp)) {
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
}
