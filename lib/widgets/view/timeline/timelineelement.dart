import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';

class TimelineElement extends StatefulWidget {
  static const headerHeight = 60.0;
  static const snap = 20.0;

  final int index;
  final TimelineItem item;
  final double left;
  final double center;
  final double verticalOffset;
  final double width;
  final double height;
  final String startTime;
  final String endTime;
  final bool hovered;
  final bool selected;
  final VoidCallback? onHover;
  final VoidCallback? onLeave;
  final VoidCallback? onSelect;

  late final double finalHeight;
  late final double top;
  late final bool isHanging;
  late final Color textColor;

  TimelineElement({
    super.key,
    required this.item,
    required this.index,
    required this.left,
    required this.center,
    required this.verticalOffset,
    required this.width,
    required this.height,
    required this.startTime,
    required this.endTime,
    this.hovered = false,
    this.selected = false,
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

    textColor =
        item.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  @override
  State<StatefulWidget> createState() => _TimelineElementState();
}

class _TimelineElementState extends State<TimelineElement> {
  Offset? _dragStart;

  Size _getSize(TextSpan textSpan) {
    final painter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return painter.size;
  }

  @override
  Widget build(BuildContext context) {
    final startSpan = TextSpan(
      text: widget.startTime,
      style: TextStyle(color: widget.textColor),
    );
    final startSize = _getSize(startSpan);

    final nameSpan = TextSpan(
      text: widget.item.name,
      style: TextStyle(color: widget.textColor, fontWeight: FontWeight.bold),
    );
    final nameSize = _getSize(nameSpan);

    final endSpan = TextSpan(
      text: widget.endTime,
      style: TextStyle(color: widget.textColor),
    );
    final endSize = _getSize(endSpan);

    final totalWidth =
        startSize.width + nameSize.width + endSize.width + 36 + 32;

    final Widget textRow;
    if (widget.width > totalWidth) {
      textRow = Row(
        spacing: 12,
        children: [
          Text.rich(startSpan),
          Expanded(child: Text.rich(nameSpan, overflow: TextOverflow.ellipsis)),
          Text.rich(endSpan),
        ],
      );
    } else if (widget.width > startSize.width + nameSize.width + 12 + 32) {
      textRow = Row(
        spacing: 12,
        children: [
          Text.rich(startSpan),
          Expanded(child: Text.rich(nameSpan, overflow: TextOverflow.ellipsis)),
        ],
      );
    } else if (widget.width > startSize.width + 32) {
      textRow = Text.rich(startSpan, textAlign: TextAlign.start);
    } else {
      textRow = SizedBox(height: nameSize.height);
    }

    return Positioned(
      left: widget.left,
      top: widget.top,
      child: MouseRegion(
        onEnter: (_) => widget.onHover?.call(),
        onExit: (_) => widget.onLeave?.call(),
        child: Listener(
          onPointerDown: (event) {
            _dragStart = event.localPosition;
          },
          onPointerUp: (event) {
            if (_dragStart == null ||
                (event.localPosition - _dragStart!).distance < 5) {
              widget.onSelect?.call();
            }
          },
          child: Tooltip(
            message:
                "${widget.item.name}\n(${widget.startTime} - ${widget.endTime})",
            child: SizedBox(
              width: widget.width,
              height: widget.finalHeight,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      widget.selected
                          ? widget.item.color
                          : (widget.hovered
                              ? widget.item.color.withAlpha(175)
                              : widget.item.color.withAlpha(150)),
                  border: Border(
                    left: BorderSide(color: widget.item.color, width: 4),
                    right: BorderSide(color: widget.item.color, width: 4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(126),
                      blurRadius: 8.0,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment:
                      widget.isHanging
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  children: [
                    Container(
                      color: widget.item.color,
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: textRow,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
