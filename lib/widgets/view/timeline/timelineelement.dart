import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';

class TimelineElement extends StatelessWidget {
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

  late final double _finalHeight;
  late final double _top;
  late final bool _isHanging;
  late final Color _textColor;

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
    _isHanging = layer < 0;

    if (layer > 0) {
      _finalHeight = height + ((layer - 1) * height * 0.75);
      _top = center - _finalHeight;
    } else {
      _finalHeight = height + ((layer.abs() - 1) * height * 0.75);
      _top = center;
    }

    _textColor =
        item.color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
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
      text: startTime,
      style: TextStyle(color: _textColor),
    );
    final startSize = _getSize(startSpan);

    final nameSpan = TextSpan(
      text: item.name,
      style: TextStyle(color: _textColor, fontWeight: FontWeight.bold),
    );
    final nameSize = _getSize(nameSpan);

    final endSpan = TextSpan(
      text: endTime,
      style: TextStyle(color: _textColor),
    );
    final endSize = _getSize(endSpan);

    final totalWidth =
        startSize.width + nameSize.width + endSize.width + 36 + 32;

    final Widget textRow;
    if (width > totalWidth) {
      textRow = Row(
        spacing: 12,
        children: [
          Text.rich(startSpan),
          Expanded(child: Text.rich(nameSpan, overflow: TextOverflow.ellipsis)),
          Text.rich(endSpan),
        ],
      );
    } else if (width > startSize.width + nameSize.width + 12 + 32) {
      textRow = Row(
        spacing: 12,
        children: [
          Text.rich(startSpan),
          Expanded(child: Text.rich(nameSpan, overflow: TextOverflow.ellipsis)),
        ],
      );
    } else if (width > startSize.width + 32) {
      textRow = Text.rich(startSpan, textAlign: TextAlign.start);
    } else {
      textRow = SizedBox(height: nameSize.height);
    }
  
    if (hovered) print(item.name);

    return Positioned(
      left: left,
      top: _top,
      child: MouseRegion(
        onEnter: (_) => onHover?.call(),
        onExit: (_) => onLeave?.call(),
        child: Listener(
          onPointerDown: (event) {
            if (onSelect != null) {
              onSelect!();
            }
          },
          child: Tooltip(
            message: "${item.name}\n(${startTime} - ${endTime})",
            child: SizedBox(
              width: width,
              height: _finalHeight,
              child: Container(
                decoration: BoxDecoration(
                  color:
                      selected
                          ? item.color
                          : (hovered
                              ? item.color.withAlpha(175)
                              : item.color.withAlpha(150)),
                  border: Border(
                    left: BorderSide(color: item.color, width: 4),
                    right: BorderSide(color: item.color, width: 4),
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
                      _isHanging
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                  children: [
                    Container(
                      color: item.color,
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
