import 'package:assignment_sem6/widgets/view/map/impl/zoombarmap.dart';
import 'package:assignment_sem6/widgets/view/map/marker/marker.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class StaticMap extends ZoomBarMap {
  final TimelineItem centralItem;

  const StaticMap({
    super.key,
    super.initialCenter,
    super.initialZoom,
    super.onZoomChanged,
    required this.centralItem,
  });

  @override
  StaticMapState createState() => StaticMapState();
}

class StaticMapState extends ZoomBarMapState<StaticMap> {
  @override
  Widget getBase() {
    final finalFiltered =
        filtered.where((item) {
          return item.key != widget.centralItem.key;
        }).toList();

    return IgnorePointer(
      child: super.buildMap(
        context,
        finalFiltered: finalFiltered,
        staticView: true,
        extraLayers: [
          MarkerLayer(
            markers: [
              MapMarker(
                item: widget.centralItem,
                staticView: true,
                visibleTimelineStart: startTimestamp,
                visibleTimelineEnd: endTimestamp,
                forceEngaged: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
