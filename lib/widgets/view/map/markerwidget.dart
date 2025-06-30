import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/widgets/view/map/markertimepainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';

class MarkerWidget extends StatefulWidget {
  final TimelineItem item;
  final int visibleTimelineStart;
  final int visibleTimelineEnd;
  final Color color;
  final double size;

  const MarkerWidget({
    super.key,
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
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          "${widget.item.name}\n${DateUtil.formatDateTime(widget.item.startTimestamp, true)} - ${DateUtil.formatDateTime(widget.item.endTimestamp, true)}",
      child: Stack(
        children: [
          Center(
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_on,
                color: Colors.white,
                size: widget.size * 0.5,
              ),
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
    );
  }
}
