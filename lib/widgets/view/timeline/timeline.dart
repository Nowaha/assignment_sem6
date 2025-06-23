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

  double _width = -1;
  double _height = -1;
  final ValueNotifier<int?> _hoveredIndex = ValueNotifier(null);

  void _setPutToFront(int index) {
    _hoveredIndex.value = index;
  }

  void _clearPutToFront() {
    _hoveredIndex.value = null;
  }

  Widget _buildChild(TimelineItem item, int index, int tickEvery) {
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
      _width,
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
        _width,
        widget.controller.visibleTimeScale,
        widget.controller.visibleCenterTimestamp,
        item,
        elementWidth,
      ),
      center: _height / 2,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stackSize = _stackKey.currentContext?.size;
      if (stackSize == null) return;

      bool anyChanges = false;
      if (_width != stackSize.width) {
        final diff = stackSize.width - _width;

        _width = stackSize.width;
        anyChanges = true;

        final timeScale = widget.controller.visibleTimeScale;
        final change = ((diff / _width) * timeScale).toInt();
        widget.controller.adjustVisibleStart(-(change ~/ 2));
        widget.controller.adjustVisibleEnd(change ~/ 2);
      }

      if (_height != stackSize.height) {
        _height = stackSize.height;
        anyChanges = true;
      }

      if (anyChanges) setState(() {});
    });

    final screenUtil = ScreenUtil(context);
    if (_width <= 0) {
      _width = screenUtil.width;
    }

    final tickEvery = widget.controller.getTickEvery(_width.toInt());

    return Stack(
      key: _stackKey,
      children: [
        Positioned.fill(
          child: TimelineZoom(
            dragSensitivity:
                widget.controller.visibleTimeScale.toDouble() / _width,
            zoom: (zoom) => widget.controller.zoom(zoom),
            pan: (pan) => widget.controller.pan(pan),
            panUp: (pan) => widget.controller.adjustVerticalOffset(pan),
            child: Stack(
              children: [
                for (int i = 0; i < widget.controller.items.length; i++)
                  _buildChild(widget.controller.items[i], i, tickEvery),

                ValueListenableBuilder<int?>(
                  valueListenable: _hoveredIndex,
                  builder: (_, hoveredIndex, __) {
                    if (hoveredIndex == null) return const SizedBox.shrink();
                    return _buildChild(
                      widget.controller.items[hoveredIndex],
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
            visibleStartTimestamp: widget.controller.visibleStartTimestamp,
            visibleEndTimestamp: widget.controller.visibleEndTimestamp,
            timescale: widget.controller.visibleTimeScale,
            centerTime: widget.controller.visibleCenterTimestamp,
            tickEvery: tickEvery,
            color: Theme.of(context).colorScheme.onSurface,
            offset: widget.controller.verticalOffset,
            offsetRounded:
                -widget.controller.items[0].layerOffset *
                widget.controller.items[0].height,
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
