import 'package:assignment_sem6/util/screen.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/widgets/view/filter/filtercontainer.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontrols.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineelement.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineline.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinezoom.dart';
import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  static const timelineItemHeight = 80.0;
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
  final ValueNotifier<int?> _hoveredIndex = ValueNotifier(null);

  void _setPutToFront(int index) {
    _hoveredIndex.value = index;
  }

  void _clearPutToFront() {
    _hoveredIndex.value = null;
  }

  Widget _buildChild(
    TimelineItem item,
    double screenWidth,
    double screenHeight,
    int index,
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
      item: item,
      onHover: () => _setPutToFront(index),
      onLeave: _clearPutToFront,
      left: TimelineUtil.getElementLeftPosition(
        screenWidth,
        widget.controller.visibleTimeScale,
        widget.controller.visibleCenterTimestamp,
        item,
        elementWidth,
      ),
      center: screenHeight / 2,
      verticalOffset: widget.controller.verticalOffset,
      width: elementWidth,
      height: elementHeight,
      startTime: startTimeString,
      endTime: endTimeString,
    );
    return element;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final screenUtil = ScreenUtil(context);

            final tickEvery = widget.controller.getTickEvery(
              size.width.toInt(),
            );

            return Stack(
              children: [
                Positioned.fill(
                  child: TimelineZoom(
                    dragSensitivity:
                        widget.controller.visibleTimeScale.toDouble() /
                        size.width,
                    zoom: (zoom) => widget.controller.zoom(zoom),
                    pan: (pan) => widget.controller.pan(pan),
                    panUp: (pan) => widget.controller.adjustVerticalOffset(pan),
                    child: Stack(
                      children: [
                        for (int i = 0; i < widget.controller.items.length; i++)
                          _buildChild(
                            widget.controller.items[i],
                            size.width,
                            size.height,
                            i,
                            tickEvery,
                          ),

                        ValueListenableBuilder<int?>(
                          valueListenable: _hoveredIndex,
                          builder: (_, hoveredIndex, __) {
                            if (hoveredIndex == null) {
                              return const SizedBox.shrink();
                            }

                            return _buildChild(
                              widget.controller.items[hoveredIndex],
                              size.width,
                              size.height,
                              hoveredIndex,
                              tickEvery,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: TimelineLine(
                    startTimestamp: widget.controller.startTimestamp,
                    endTimestamp: widget.controller.endTimestamp,
                    visibleStartTimestamp:
                        widget.controller.visibleStartTimestamp,
                    visibleEndTimestamp: widget.controller.visibleEndTimestamp,
                    timescale: widget.controller.visibleTimeScale,
                    centerTime: widget.controller.visibleCenterTimestamp,
                    tickEvery: tickEvery,
                    color: Theme.of(context).colorScheme.onSurface,
                    offset: widget.controller.verticalOffset,
                    offsetRounded:
                        -widget.controller.items[0].layerOffset *
                        Timeline.timelineItemHeight,
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
                          onScrollUp:
                              () => widget.controller.adjustVerticalOffset(-50),
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
          },
        );
      },
    );
  }
}
