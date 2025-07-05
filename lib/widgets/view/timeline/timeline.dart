import 'package:assignment_sem6/util/screen.dart';
import 'package:assignment_sem6/util/timelineutil.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontrols.dart';
import 'package:assignment_sem6/widgets/view/timeline/widget/timelineitemwidget.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineindicator.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelineline.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinezoom.dart';
import 'package:flutter/material.dart';

class Timeline extends StatefulWidget {
  static const timelineItemHeight = 80.0;
  final TimelineController controller;
  final VoidCallback? onMapButtonPressed;
  final VoidCallback? expandLeft;
  final VoidCallback? expandRight;

  const Timeline({
    super.key,
    required this.controller,
    this.expandLeft,
    this.expandRight,
    this.onMapButtonPressed,
  });

  @override
  State<StatefulWidget> createState() => TimelineState();
}

class TimelineState extends State<Timeline> {
  final ValueNotifier<String?> _hovered = ValueNotifier(null);

  Widget _buildChild(
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
      widget.controller.visibleTimeScale,
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
        _hovered.value = item.key;
      },
      onLeave: () {
        _hovered.value = null;
      },
      onSelect: () {
        if (widget.controller.selectedItem.value != item.key) {
          widget.controller.selectedItem.value = item.key;
        } else {
          widget.controller.selectedItem.value = null;
        }
      },
      left: TimelineUtil.getElementLeftPosition(
        screenWidth,
        widget.controller.visibleTimeScale,
        widget.controller.visibleCenterTimestamp,
        item,
        elementWidth,
      ),
      center: screenHeight / 2,
      width: elementWidth,
      height: elementHeight,
      includeSeconds: tickEvery < 1000 * 60 || hovered,
      selected: widget.controller.selectedItem.value == item.key,
    );
    return element;
  }

  @override
  Widget build(BuildContext context) {
    final listenables = Listenable.merge([
      widget.controller,
      widget.controller.selectedItem,
      _hovered,
    ]);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return ListenableBuilder(
          listenable: listenables,
          builder: (context, _) {
            final screenUtil = ScreenUtil(context);

            final tickEvery = widget.controller.getTickEvery(
              size.width.toInt(),
            );

            final visibleItems = widget.controller.getVisibleItems();
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
                              item,
                              size.width,
                              size.height,
                              tickEvery,
                            ),

                          if (widget.controller.selectedItem.value != null &&
                              widget.controller.selectedItem.value !=
                                  _hovered.value)
                            _buildChild(
                              widget.controller.itemsMap[widget
                                  .controller
                                  .selectedItem
                                  .value!],
                              size.width,
                              size.height,
                              tickEvery,
                              hovered: true,
                              inFront: true,
                            ),

                          if (_hovered.value != null)
                            _buildChild(
                              widget.controller.itemsMap[_hovered.value!]!,
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
                          onRecenter: () => widget.controller.recenter(),
                        ),
                    ],
                  ),
                ),
                TimelineIndicator(
                  controller: widget.controller,
                  timelineHeight: size.height,
                  isLeft: true,
                  expand: widget.expandLeft,
                ),
                TimelineIndicator(
                  controller: widget.controller,
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
