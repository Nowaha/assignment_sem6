import 'package:assignment_sem6/widgets/view/timeline/timelineitem.dart';
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

  @override
  State<StatefulWidget> createState() => _TimelineElementState();
}

class _TimelineElementState extends State<TimelineElement> {
  bool _isHovered = false;

  void _onHover(_) {
    if (widget.onHover != null) {
      widget.onHover!();
    }

    setState(() {
      _isHovered = true;
    });
  }

  void _onLeave(_) {
    if (widget.onLeave != null) {
      widget.onLeave!();
    }
    setState(() {
      _isHovered = false;
    });
  }

  @override
  Widget build(BuildContext context) => Positioned(
    left: widget.left,
    top: widget._top,
    child: RepaintBoundary(
      child: MouseRegion(
        onEnter: _onHover,
        onExit: _onLeave,
        child: SizedBox(
          width: widget.width,
          height: widget._finalHeight,
          child: Container(
            decoration: BoxDecoration(
              color:
                  _isHovered
                      ? widget.item.color.withAlpha(175)
                      : widget.item.color.withAlpha(150),
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
                  widget._isHanging
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
              children: [
                Container(
                  color: widget.item.color,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Tooltip(
                      message: widget.item.name,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        spacing: 12,
                        children: [
                          Text(
                            widget.startTime,
                            style: TextStyle(color: widget._textColor),
                          ),
                          Expanded(
                            child: Text(
                              widget.item.name,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: widget._textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            widget.endTime,
                            style: TextStyle(color: widget._textColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
