import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/widgets/mouse/clicklistener.dart';
import 'package:assignment_sem6/widgets/view/map/markertimepainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MarkerWidget extends StatefulWidget {
  final TimelineItem item;
  final bool staticView;
  final int visibleTimelineStart;
  final int visibleTimelineEnd;
  final Color color;
  final double size;

  const MarkerWidget({
    super.key,
    required this.item,
    this.staticView = false,
    required this.visibleTimelineStart,
    required this.visibleTimelineEnd,
    this.color = Colors.red,
    this.size = 24,
  });

  @override
  State<MarkerWidget> createState() => _MarkerWidgetState();
}

class _MarkerWidgetState extends State<MarkerWidget> {
  late final TimelineState _timelineState;
  bool _hovering = false;
  bool _selected = false;

  @override
  void initState() {
    _timelineState = context.read<TimelineState>();
    _timelineState.selectedItem.addListener(_onSelectedItemChanged);
    _onSelectedItemChanged();

    super.initState();
  }

  @override
  void dispose() {
    _timelineState.selectedItem.removeListener(_onSelectedItemChanged);
    super.dispose();
  }

  void _onSelectedItemChanged() {
    final timelineState = context.read<TimelineState>();
    bool isSelected = timelineState.selectedItem.value == widget.item.key;
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
        if (widget.staticView) return;
        setState(() {
          _hovering = true;
        });
      },
      onExit: (_) {
        if (widget.staticView) return;
        setState(() {
          _hovering = false;
        });
      },
      child: ClickListener(
        onClick: () {
          if (widget.staticView) return;
          final timelineState = context.read<TimelineState>();
          if (timelineState.selectedItem.value == widget.item.key) {
            timelineState.selectedItem.value = null;
          } else {
            timelineState.selectedItem.value = widget.item.key;
          }
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
