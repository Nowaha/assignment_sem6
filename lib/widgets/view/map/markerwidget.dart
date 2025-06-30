import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/widgets/view/map/markertimepainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter/material.dart';

class MarkerWidget extends StatefulWidget {
  final TimelineController controller;
  final TimelineItem item;
  final int visibleTimelineStart;
  final int visibleTimelineEnd;
  final Color color;
  final double size;

  const MarkerWidget({
    super.key,
    required this.controller,
    required this.item,
    required this.visibleTimelineStart,
    required this.visibleTimelineEnd,
    this.color = Colors.red,
    this.size = 24,
  });

  @override
  State<MarkerWidget> createState() => _MarkerWidgetState();
}

class _MarkerWidgetState extends State<MarkerWidget> {
  bool _hovering = false;
  bool _selected = false;
  Offset? _downAt;

  @override
  void initState() {
    widget.controller.selectedItem.addListener(_onSelectedItemChanged);
    _onSelectedItemChanged();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.selectedItem.removeListener(_onSelectedItemChanged);
    super.dispose();
  }

  void _onSelectedItemChanged() {
    bool isSelected = widget.controller.selectedItem.value == widget.item.key;
    if (isSelected != _selected) {
      setState(() {
        _selected = isSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool engaged = _hovering || _selected;

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _hovering = false;
        });
      },
      child: Listener(
        onPointerDown: (event) {
          _downAt = event.localPosition;
        },
        onPointerUp: (event) {
          if (_downAt != null &&
              (event.localPosition - _downAt!).distance < 10) {
            if (widget.controller.selectedItem.value == widget.item.key) {
              widget.controller.selectedItem.value = null;
            } else {
              widget.controller.selectedItem.value = widget.item.key;
            }
          }
          _downAt = null;
        },
        child: Tooltip(
          message:
              "${widget.item.name}\n${DateUtil.formatDateTime(widget.item.startTimestamp, true)} - ${DateUtil.formatDateTime(widget.item.endTimestamp, true)}",
          child: Stack(
            children: [
              Center(
                child: Container(
                  width: widget.size,
                  height: widget.size,
                  decoration: BoxDecoration(
                    color: engaged ? widget.color : widget.color.withAlpha(50),
                    shape: BoxShape.circle,
                    border: Border.all(color: widget.color, width: 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(100),
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child:
                      engaged
                          ? Icon(
                            Icons.location_on,
                            color: Colors.white,
                            size: widget.size * 0.5,
                          )
                          : null,
                ),
              ),
              CustomPaint(
                size: Size(widget.size * 1.5, widget.size),
                painter: MarkerTimePainter(
                  offset: Offset(widget.size / 4, 20),
                  startTimestamp: widget.item.startTimestamp,
                  endTimestamp: widget.item.endTimestamp,
                  timelineStartTimestamp: widget.visibleTimelineStart,
                  timelineEndTimestamp: widget.visibleTimelineEnd,
                  color: widget.color,
                  timelineColor: Colors.white,
                  thickness: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
