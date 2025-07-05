import 'package:assignment_sem6/widgets/view/map/markerwidget.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter_map/flutter_map.dart';

class MapMarker extends Marker {
  final TimelineItem item;
  final bool staticView;
  final double size;
  final int visibleTimelineStart;
  final int visibleTimelineEnd;

  MapMarker({
    required this.item,
    this.staticView = false,
    this.size = 32,
    required this.visibleTimelineStart,
    required this.visibleTimelineEnd,
  }) : super(
         point: item.location,
         width: size * 2,
         child: MarkerWidget(
           item: item,
           staticView: staticView,
           color: item.color,
           size: size,
           visibleTimelineStart: visibleTimelineStart,
           visibleTimelineEnd: visibleTimelineEnd,
         ),
         rotate: true,
       );
}
