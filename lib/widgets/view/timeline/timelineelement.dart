import 'package:flutter/material.dart';

class TimelineElement extends StatefulWidget {
  final double left;
  final double center;
  final double width;
  final double height;
  final Color color;
  final String startTime;
  final String name;
  final String endTime;
  final int layer;

  late final double _finalHeight;
  late final double _top;
  late final bool _isHanging;
  late final Color _textColor;

  TimelineElement({
    super.key,
    required this.left,
    required this.center,
    required this.width,
    required this.height,
    required this.color,
    required this.startTime,
    required this.name,
    required this.endTime,
    this.layer = 0,
  }) {
    _isHanging = layer > 0 && layer % 2 == 0;

    if (layer == 0) {
      _finalHeight = height;
    } else if (layer == 1) {
      _finalHeight = height * 2;
    } else if (layer % 2 == 0) {
      _finalHeight = height * (layer / 2);
    } else {
      _finalHeight = height * ((layer + 1) / 2);
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

  @override
  Widget build(BuildContext context) => Positioned(
    left: widget.left,
    top: widget._top,
    child: MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: SizedBox(
        width: widget.width,
        height: widget._finalHeight,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          decoration: BoxDecoration(
            color: !_isHovered ? widget.color.withAlpha(126) : widget.color,
            border: Border(
              left: BorderSide(color: widget.color, width: 4),
              right: BorderSide(color: widget.color, width: 4),
            ),
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
  );
}
