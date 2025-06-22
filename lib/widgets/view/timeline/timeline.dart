import 'package:assignment_sem6/util/screen.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/widgets/view/filter/filtercontainer.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontrols.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineelement.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineitem.dart';
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

  double _center = 99999;
  final ValueNotifier<int?> _hoveredIndex = ValueNotifier(null);

  void _setPutToFront(int index) {
    _hoveredIndex.value = index;
  }

  void _clearPutToFront() {
    _hoveredIndex.value = null;
  }

  void recalculateCenter(double height) {
    setState(() {
      _center = height / 2;
    });
  }

  Widget _buildChild(
    TimelineItem item,
    int index,
    double screenWidth,
    int tickEvery,
  ) {
    final startTime = DateTime.fromMillisecondsSinceEpoch(item.startTimestamp);
    final endTime = DateTime.fromMillisecondsSinceEpoch(item.endTimestamp);
    String startTimeString =
        "${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}";
    String endTimeString =
        "${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}";

    if (tickEvery < 1000 * 60 || _hoveredIndex.value == index) {
      startTimeString += ":${startTime.second.toString().padLeft(2, '0')}";
      endTimeString += ":${endTime.second.toString().padLeft(2, '0')}";
    }

    final elementWidth = TimelineUtil.getElementWidth(
      screenWidth,
      widget.controller.visibleTimeScale,
      item.startTimestamp,
      item.endTimestamp,
    );
    final elementHeight = 80.0;

    final element = TimelineElement(
      index: index,
      onHover: () => _setPutToFront(index),
      onLeave: _clearPutToFront,
      left: TimelineUtil.getElementLeftPosition(
        screenWidth,
        widget.controller.visibleTimeScale,
        widget.controller.visibleCenterTimestamp,
        item,
        elementWidth,
      ),
      center: _center,
      verticalOffset: widget.controller.verticalOffset,
      layer: item.layer,
      width: elementWidth,
      height: elementHeight,
      color: item.color,
      startTime: startTimeString,
      name: item.name,
      endTime: endTimeString,
    );
    return element;
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
    final tickEvery = widget.controller.getTickEvery(screenWidth.toInt());

    return Stack(
      key: _stackKey,
      children: [
        Positioned.fill(
          child: TimelineZoom(
            dragSensitivity:
                widget.controller.visibleTimeScale.toDouble() / screenWidth,
            zoom: (zoom) => widget.controller.zoom(zoom),
            pan: (pan) => widget.controller.pan(pan),
            panUp: (pan) => widget.controller.adjustVerticalOffset(pan),
            child: Stack(
              children: [
                for (int i = 0; i < widget.controller.items.length; i++)
                  _buildChild(
                    widget.controller.items[i],
                    i,
                    screenWidth,
                    tickEvery,
                  ),

                ValueListenableBuilder<int?>(
                  valueListenable: _hoveredIndex,
                  builder: (_, hoveredIndex, __) {
                    if (hoveredIndex == null) return const SizedBox.shrink();
                    return _buildChild(
                      widget.controller.items[hoveredIndex],
                      hoveredIndex,
                      screenWidth,
                      tickEvery,
                    );
                  },
                ),
              ],
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
              tickEvery: tickEvery,
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
                  onScrollUp: () => widget.controller.adjustVerticalOffset(-50),
                  onScrollDown:
                      () => widget.controller.adjustVerticalOffset(50),
                  onCenter: () => widget.controller.recenter(),
                ),
            ],
          ),
        ),
        Positioned(
          left: 16,
          top: 16,
          child: RepaintBoundary(child: FilterContainer()),
        ),
      ],
    );
  }
}
