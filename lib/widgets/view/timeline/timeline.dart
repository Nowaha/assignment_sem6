import 'package:assignment_sem6/util/screen.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/widgets/view/filter/filtercontainer.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimap.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontrols.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineelement.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineline.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinezoom.dart';
import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  final TimelineController controller;
  final VoidCallback? onMapButtonPressed;

  const Timeline({
    super.key,
    required this.controller,
    this.onMapButtonPressed,
  });

  @override
  State<StatefulWidget> createState() => TimelineState();
}

class TimelineState extends State<Timeline> {
  final GlobalKey _stackKey = GlobalKey();

  double center = 99999;

  @override
  void initState() {
    super.initState();

    final startTimestamp = widget.controller.visibleStartTimestamp;
    final endTimestamp = widget.controller.visibleEndTimestamp;

    arrangeElements([
      TempPost(
        startTimestamp: startTimestamp,
        endTimestamp: startTimestamp + (1000 * 60 * 10),
        name: "Post 1",
        color: Colors.red,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 10),
        endTimestamp: startTimestamp + (1000 * 60 * 20),
        name: "Post 2",
        color: Colors.blue,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 15),
        endTimestamp: startTimestamp + (1000 * 60 * 30),
        name: "Post 3",
        color: Colors.green,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 23),
        endTimestamp: startTimestamp + (1000 * 60 * 50),
        name: "Post 4",
        color: Colors.orange,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 25),
        endTimestamp: startTimestamp + (1000 * 60 * 40),
        name: "Post 5",
        color: Colors.purple,
      ),
      TempPost(
        startTimestamp: startTimestamp + (1000 * 60 * 50),
        endTimestamp: startTimestamp + (1000 * 60 * 60),
        name: "Post 6",
        color: Colors.yellow,
      ),
    ]);
  }

  void arrangeElements(List<TempPost> posts) {
    final sorted = posts;
    sorted.sort((a, b) => a.startTimestamp.compareTo(b.startTimestamp));

    final List<TimelineItem> arranged = [];

    for (int i = 0; i < sorted.length; i++) {
      final post = sorted[i];

      int layer = TimelineUtil.resolveLayer(post, arranged);

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

    arranged.sort((a, b) => a.startTimestamp.compareTo(b.startTimestamp));

    widget.controller.updateItems(arranged);
  }

  void recalculateCenter(double height) {
    setState(() {
      center = height / 2;
    });
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
            zoom: (zoom) => widget.controller.zoom(zoom),
            pan: (pan) => widget.controller.pan(pan),
            child: Stack(
              children:
                  widget.controller.items.map((item) {
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

                    final elementWidth = TimelineUtil.getElementWidth(
                      screenWidth,
                      widget.controller.visibleTimeScale,
                      item.startTimestamp,
                      item.endTimestamp,
                    );
                    final elementHeight = 80.0;

                    final element = TimelineElement(
                      left: TimelineUtil.getElementLeftPosition(
                        screenWidth,
                        widget.controller.visibleTimeScale,
                        widget.controller.visibleCenterTimestamp,
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
              startTimestamp: widget.controller.visibleStartTimestamp,
              endTimestamp: widget.controller.visibleEndTimestamp,
              timescale: widget.controller.visibleTimeScale,
              centerTime: widget.controller.visibleCenterTimestamp,
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
                  onZoomIn: () => widget.controller.zoom(1.2),
                  onZoomOut: () => widget.controller.zoom(0.8),
                  onResetZoom: () => widget.controller.resetZoom(),
                  onScrollLeft:
                      () => widget.controller.pan(
                        -widget.controller.visibleTimeScale ~/ 10,
                      ),
                  onScrollRight:
                      () => widget.controller.pan(
                        widget.controller.visibleTimeScale ~/ 10,
                      ),
                  onCenter: () => widget.controller.recenter(),
                ),
            ],
          ),
        ),
        Positioned(left: 16, top: 16, child: FilterContainer()),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: TimelineMiniMap(controller: widget.controller),
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
