import 'package:assignment_sem6/widgets/mouse/clickhoverlistener.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:assignment_sem6/widgets/view/timeline/widget/timelineheader.dart';
import 'package:flutter/material.dart';

class TimelineWidget extends StatefulWidget {
  static const headerHeight = 60.0;
  static const snap = 20.0;

  final TimelineItem item;
  final double left;
  final double center;
  final double width;
  final double height;
  final bool includeSeconds;
  final bool hovered;
  final bool selected;
  final bool inFront;
  final VoidCallback? onHover;
  final VoidCallback? onLeave;
  final VoidCallback? onSelect;

  late final double finalHeight;
  late final double top;
  late final bool isHanging;

  TimelineWidget({
    super.key,
    required this.item,
    required this.left,
    required this.center,
    required this.width,
    required this.height,
    required this.includeSeconds,
    this.hovered = false,
    this.selected = false,
    this.inFront = false,
    this.onHover,
    this.onLeave,
    this.onSelect,
  }) {
    final layer = item.effectiveLayer;
    isHanging = layer < 0;

    if (layer > 0) {
      finalHeight = height + ((layer - 1) * height * 0.75);
      top = center - finalHeight;
    } else {
      finalHeight = height + ((layer.abs() - 1) * height * 0.75);
      top = center;
    }
  }

  @override
  State<StatefulWidget> createState() => _TimelineWidgetState();
}

class _TimelineWidgetState extends State<TimelineWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.left,
      top: widget.top,
      child: SizedBox(
        width: widget.width,
        height: widget.finalHeight,
        child: IgnorePointer(
          ignoring: widget.inFront,
          child: Container(
            decoration: BoxDecoration(
              color:
                  widget.inFront
                      ? widget.item.color.withAlpha(100)
                      : (widget.selected || widget.hovered
                          ? widget.item.color
                          : widget.item.color.withAlpha(150)),
              border: Border(
                left: BorderSide(color: widget.item.color, width: 4),
                right: BorderSide(color: widget.item.color, width: 4),
              ),
              boxShadow:
                  !widget.inFront
                      ? [
                        BoxShadow(
                          color: Colors.black.withAlpha(126),
                          blurRadius: 8.0,
                          offset: const Offset(2, 2),
                        ),
                      ]
                      : [],
            ),
            child: Column(
              mainAxisAlignment:
                  widget.isHanging
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [
                ClickHoverListener(
                  onClick: () => widget.onSelect?.call(),
                  mouseEnter: widget.onHover ?? () {},
                  mouseLeave: widget.onLeave ?? () {},
                  child: TimelineHeader(
                    item: widget.item,
                    width: widget.width,
                    includeSeconds: widget.includeSeconds || widget.inFront,
                    isHanging: widget.isHanging,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
