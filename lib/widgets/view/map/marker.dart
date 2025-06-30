import 'package:assignment_sem6/widgets/view/map/markerwidget.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter_map/flutter_map.dart';

class MapMarker extends Marker {
  final double size;
  final TimelineController controller;
  final TimelineItem item;
  final int visibleTimelineStart;
  final int visibleTimelineEnd;

  MapMarker({
    this.size = 32,
    required this.controller,
    required this.item,
    required this.visibleTimelineStart,
    required this.visibleTimelineEnd,
  }) : super(
         point: item.location,
         width: size * 2,
         child: MarkerWidget(
           controller: controller,
           item: item,
           color: item.color,
           size: size,
           visibleTimelineStart: visibleTimelineStart,
           visibleTimelineEnd: visibleTimelineEnd,
         ),
         rotate: true,
       );
}
