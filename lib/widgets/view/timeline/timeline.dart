import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/util/screen.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontrols.dart';
import 'package:assignment_sem6/widgets/view/timeline/widget/timelineitemwidget.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineindicator.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineline.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinezoom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Timeline extends StatefulWidget {
  static const timelineItemHeight = 80.0;
  final VoidCallback? onMapButtonPressed;
  final VoidCallback? expandLeft;
  final VoidCallback? expandRight;

  const Timeline({
    super.key,
    this.expandLeft,
    this.expandRight,
    this.onMapButtonPressed,
  });

  @override
  State<StatefulWidget> createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  Widget _buildChild(
    TimelineState timelineState,
    TimelineItem? item,
    double screenWidth,
    double screenHeight,
    int tickEvery, {
    bool hovered = false,
    bool inFront = false,
  }) {
    if (item == null) {
      return SizedBox.shrink();
    }

    final elementWidth = TimelineUtil.getElementWidth(
      screenWidth,
      timelineState.visibleTimeScale,
      item.startTimestamp,
      item.endTimestamp,
    );
    final elementHeight = 80.0;

    final element = TimelineItemWidget(
      key: ValueKey(
        item.key + (hovered ? "-hovered" : (inFront ? "-infront" : "")),
      ),
      item: item,
      hovered: hovered,
      inFront: inFront,
      onHover: () {
        timelineState.hoveredItem.value = item.key;
      },
      onLeave: () {
        timelineState.hoveredItem.value = null;
      },
      onSelect: () {
        if (timelineState.selectedItem.value != item.key) {
          timelineState.selectedItem.value = item.key;
        } else {
          timelineState.selectedItem.value = null;
        }
      },
      left: TimelineUtil.getElementLeftPosition(
        screenWidth,
        timelineState.visibleTimeScale,
        timelineState.visibleCenterTimestamp,
        item,
        elementWidth,
      ),
      layerShiftMode: timelineState.layerShiftMode,
      center:
          screenHeight / 2 -
          (timelineState.layerShiftMode ? 0.0 : timelineState.verticalOffset),
      width: elementWidth,
      height: elementHeight,
      includeSeconds: tickEvery < 1000 * 60 || hovered,
      selected: timelineState.selectedItem.value == item.key,
    );
    return element;
  }

  @override
  Widget build(BuildContext context) {
    final timelineState = context.watch<TimelineState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return ListenableBuilder(
          listenable: timelineState.hoveredItem,
          builder: (context, _) {
            final screenUtil = ScreenUtil(context);

            final tickEvery = timelineState.getTickEvery(size.width.toInt());

            final visibleItems = timelineState.getVisibleItems();
            return Stack(
              children: [
                Positioned.fill(
                  child: TimelineZoom(
                    dragSensitivity:
                        timelineState.visibleTimeScale.toDouble() / size.width,
                    zoom: (zoom) => timelineState.zoom(zoom),
                    pan: (pan) => timelineState.pan(pan),
                    panUp: (pan) => timelineState.adjustVerticalOffset(pan),
                    child: ShaderMask(
                      shaderCallback: (bounds) {
                        return LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withAlpha(50),
                            Colors.black,
                            Colors.black,
                            Colors.black.withAlpha(50),
                          ],
                          stops: [0.0, 0.02, 0.98, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Stack(
                        children: [
                          for (final item in visibleItems)
                            _buildChild(
                              timelineState,
                              item,
                              size.width,
                              size.height,
                              tickEvery,
                            ),

                          if (timelineState.selectedItem.value != null &&
                              timelineState.selectedItem.value !=
                                  timelineState.hoveredItem.value)
                            _buildChild(
                              timelineState,
                              timelineState.itemsMap[timelineState
                                  .selectedItem
                                  .value!],
                              size.width,
                              size.height,
                              tickEvery,
                              hovered: true,
                              inFront: true,
                            ),

                          if (timelineState.hoveredItem.value != null)
                            _buildChild(
                              timelineState,
                              timelineState.itemsMap[timelineState
                                  .hoveredItem
                                  .value!]!,
                              size.width,
                              size.height,
                              tickEvery,
                              hovered: true,
                              inFront: true,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: TimelineLine(
                    startTimestamp: timelineState.startTimestamp,
                    endTimestamp: timelineState.endTimestamp,
                    visibleStartTimestamp: timelineState.visibleStartTimestamp,
                    visibleEndTimestamp: timelineState.visibleEndTimestamp,
                    timescale: timelineState.visibleTimeScale,
                    centerTime: timelineState.visibleCenterTimestamp,
                    tickEvery: tickEvery,
                    color: Theme.of(context).colorScheme.onSurface,
                    offset: timelineState.verticalOffset,
                    layerShiftMode: timelineState.layerShiftMode,
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
                          iconSize: 24,
                          padding: EdgeInsets.all(12),
                        ),
                      if (screenUtil.isBigScreen)
                        TimelineControls(
                          onZoomIn: () => timelineState.zoom(1.2),
                          onZoomOut: () => timelineState.zoom(0.8),
                          onResetZoom: () => timelineState.resetZoom(),
                          onScrollLeft:
                              () => timelineState.pan(
                                -timelineState.visibleTimeScale ~/ 10,
                              ),
                          onScrollRight:
                              () => timelineState.pan(
                                timelineState.visibleTimeScale ~/ 10,
                              ),
                          onScrollUp:
                              () => timelineState.adjustVerticalOffset(-50),
                          onScrollDown:
                              () => timelineState.adjustVerticalOffset(50),
                          onRecenter: () => timelineState.recenter(),
                        ),
                    ],
                  ),
                ),
                TimelineIndicator(
                  timelineHeight: size.height,
                  isLeft: true,
                  expand: widget.expandLeft,
                ),
                TimelineIndicator(
                  timelineHeight: size.height,
                  isLeft: false,
                  expand: widget.expandRight,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
