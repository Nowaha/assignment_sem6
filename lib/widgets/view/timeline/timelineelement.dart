import 'package:flutter/material.dart';

class TimelineElement extends StatefulWidget {
  final int index;
  final double left;
  final double center;
  final double width;
  final double height;
  final String name;
  final Color color;
  final String startTime;
  final String endTime;
  final int layer;
  final VoidCallback? onHover;
  final VoidCallback? onLeave;
  final VoidCallback? onSelect;

  late final double _finalHeight;
  late final double _top;
  late final bool _isHanging;
  late final Color _textColor;

  TimelineElement({
    super.key,
    required this.index,
    required this.left,
    required this.center,
    required this.width,
    required this.height,
    required this.name,
    required this.color,
    required this.startTime,
    required this.endTime,
    this.onHover,
    this.onLeave,
    this.onSelect,
    this.layer = 0,
  }) {
    _isHanging = layer > 0 && layer % 2 == 0;

    int layerOnHalf;
    if (layer == 0) {
      layerOnHalf = 1;
      _finalHeight = height;
    } else if (layer % 2 == 0) {
      layerOnHalf = layer ~/ 2;

      if (layer == 1) {
        _finalHeight = height;
      } else {
        _finalHeight = height + ((layerOnHalf - 1) * height * 0.75);
      }
    } else {
      layerOnHalf = ((layer + 1) ~/ 2) + 1;
      _finalHeight = height + ((layerOnHalf - 1) * height * 0.75);
    }

    if (_isHanging) {
      _top = center;
    } else {
      _top = center - _finalHeight;
    }

    _textColor = color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
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
              color: !_isHovered ? widget.color.withAlpha(126) : widget.color,
              border: Border(
                left: BorderSide(color: widget.color, width: 4),
                right: BorderSide(color: widget.color, width: 4),
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
                  color: widget.color,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Tooltip(
                      message: widget.name,
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
                              widget.name,
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
