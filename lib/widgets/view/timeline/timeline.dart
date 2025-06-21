import 'package:assignment_sem6/util/screen.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontrols.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineelement.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineline.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinezoom.dart';
import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  final int startTimestamp;
  final int endTimestamp;
  final VoidCallback? onMapButtonPressed;

  const Timeline({
    super.key,
    required this.startTimestamp,
    required this.endTimestamp,
    this.onMapButtonPressed,
  });

  @override
  State<StatefulWidget> createState() => TimelineState();
}

class TimelineState extends State<Timeline> {
  final GlobalKey _stackKey = GlobalKey();
  final double timeScale = 1000 * 60 * 60; // Screen displays 1 hour of time

  double zoom = 1.0;
  double get effectiveTimeScale => timeScale / zoom;
  int centerTime = 0;
  final List<TimelineItem> timestamps = [];

  double center = 0;

  @override
  void initState() {
    super.initState();

    centerTime =
        widget.startTimestamp +
        ((widget.endTimestamp - widget.startTimestamp) ~/ 2);

    arrangeElements([
      TempPost(
        startTimestamp: widget.startTimestamp,
        endTimestamp: widget.startTimestamp + (1000 * 60 * 10),
        name: "Post 1",
        color: Colors.red,
      ),
      TempPost(
        startTimestamp: widget.startTimestamp + (1000 * 60 * 10),
        endTimestamp: widget.startTimestamp + (1000 * 60 * 20),
        name: "Post 2",
        color: Colors.blue,
      ),
      TempPost(
        startTimestamp: widget.startTimestamp + (1000 * 60 * 15),
        endTimestamp: widget.startTimestamp + (1000 * 60 * 30),
        name: "Post 3",
        color: Colors.green,
      ),
      TempPost(
        startTimestamp: widget.startTimestamp + (1000 * 60 * 23),
        endTimestamp: widget.startTimestamp + (1000 * 60 * 50),
        name: "Post 4",
        color: Colors.orange,
      ),
      TempPost(
        startTimestamp: widget.startTimestamp + (1000 * 60 * 25),
        endTimestamp: widget.startTimestamp + (1000 * 60 * 40),
        name: "Post 5",
        color: Colors.purple,
      ),
      TempPost(
        startTimestamp: widget.startTimestamp + (1000 * 60 * 50),
        endTimestamp: widget.startTimestamp + (1000 * 60 * 60),
        name: "Post 6",
        color: Colors.yellow,
      ),
    ]);

    timestamps.sort((a, b) => b.layer.abs().compareTo(a.layer.abs()));
  }

  void arrangeElements(List<TempPost> posts) {
    final sorted = posts;
    sorted.sort((a, b) => a.startTimestamp.compareTo(b.startTimestamp));

    final List<TimelineItem> arranged = [];

    for (int i = 0; i < sorted.length; i++) {
      final post = sorted[i];

      int layer = resolveLayer(post, arranged);

      arranged.add(
        TimelineItem(
          startTimestamp: post.startTimestamp,
          endTimestamp: post.endTimestamp,
          name: post.name,
          height: 80.0,
          width: 300.0,
          layer: layer,
          color: post.color,
        ),
      );
    }

    setState(() {
      timestamps.clear();
      timestamps.addAll(arranged);
    });
  }

  int resolveLayer(TempPost post, List<TimelineItem> previousItems) {
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

  void recalculateCenter(double height) {
    setState(() {
      center = height / 2;
    });
  }

  double getElementLeftPosition(
    double screenWidth,
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

  double getElementWidth(
    double screenWidth,
    int startTimestamp,
    int endTimestamp,
  ) {
    return (endTimestamp.toDouble() - startTimestamp.toDouble()) /
        effectiveTimeScale *
        screenWidth;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stackHeight = _stackKey.currentContext?.size?.height;
      if (stackHeight != null) {
        recalculateCenter(stackHeight);
      }
    });

    final screenUtil = ScreenUtil(context);
    final screenWidth = screenUtil.width;

    return Stack(
      key: _stackKey,
      children: [
        Positioned.fill(
          child: TimelineZoom(
            zoom: zoom,
            onZoomChanged:
                (zoom) => setState(() {
                  this.zoom = zoom;
                }),
            centerTime: centerTime,
            onCenterTimeChanged:
                (centerTime) => setState(() {
                  this.centerTime = centerTime;
                }),
            child: Stack(
              children:
                  timestamps.map((item) {
                    final startTime = DateTime.fromMillisecondsSinceEpoch(
                      item.startTimestamp,
                    );
                    final endTime = DateTime.fromMillisecondsSinceEpoch(
                      item.endTimestamp,
                    );
                    final startTimeString =
                        "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}:${startTime.second.toString().padLeft(2, '0')}";
                    final endTimeString =
                        "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}:${endTime.second.toString().padLeft(2, '0')}";

                    final elementWidth = getElementWidth(
                      screenWidth,
                      item.startTimestamp,
                      item.endTimestamp,
                    );
                    final elementHeight = 80.0;

                    final element = TimelineElement(
                      left: getElementLeftPosition(
                        screenWidth,
                        item,
                        elementWidth,
                      ),
                      center: center,
                      layer: item.layer,
                      width: elementWidth,
                      height: elementHeight,
                      color: item.color,
                      startTime: startTimeString,
                      name: item.name,
                      endTime: endTimeString,
                    );
                    return element;
                  }).toList(),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: TimelineLine(
              startTimestamp: widget.startTimestamp,
              endTimestamp: widget.endTimestamp,
              timescale: effectiveTimeScale,
              centerTime: centerTime,
              tickEvery: 1000 * 60 * 5, // 5 minutes
            ),
          ),
        ),
        Positioned(
          right: 16,
          top: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            spacing: 16,
            children: [
              if (widget.onMapButtonPressed != null)
                IconButton.filled(
                  onPressed: widget.onMapButtonPressed,
                  icon: const Icon(Icons.map),
                  iconSize: 32,
                  padding: EdgeInsets.all(16),
                ),
              if (screenUtil.isBigScreen)
                TimelineControls(
                  onZoomIn:
                      () => setState(() {
                        zoom = (zoom * 1.2).clamp(0.1, 10.0);
                      }),
                  onZoomOut:
                      () => setState(() {
                        zoom = (zoom / 1.2).clamp(0.1, 10.0);
                      }),
                  onResetZoom:
                      () => setState(() {
                        zoom = 1.0;
                      }),
                  onScrollLeft:
                      () => setState(() {
                        centerTime -= (effectiveTimeScale * 0.1).toInt();
                      }),
                  onScrollRight:
                      () => setState(() {
                        centerTime += (effectiveTimeScale * 0.1).toInt();
                      }),
                  onCenter:
                      () => setState(() {
                        centerTime =
                            widget.startTimestamp +
                            ((widget.endTimestamp - widget.startTimestamp) ~/
                                2);
                      }),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class TempPost {
  final int startTimestamp;
  final int endTimestamp;
  final String name;
  final Color color;

  const TempPost({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.name,
    this.color = Colors.purple,
  });
}

class TimelineItem {
  final int startTimestamp;
  final int endTimestamp;
  final String name;
  final double height;
  final double width;
  final int layer;
  final Color color;

  const TimelineItem({
    required this.startTimestamp,
    required this.endTimestamp,
    required this.name,
    required this.height,
    required this.width,
    this.color = Colors.purple,
    this.layer = 0,
  });
}
