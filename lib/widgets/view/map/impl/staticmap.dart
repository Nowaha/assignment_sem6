import 'package:assignment_sem6/widgets/view/map/basemap.dart';
import 'package:assignment_sem6/widgets/view/map/marker/marker.dart';
import 'package:assignment_sem6/widgets/view/map/zoom/mapzoom.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class StaticMap extends BaseMapWidget {
  final TimelineItem centralItem;
  final bool peekable;

  const StaticMap({
    super.key,
    super.initialCenter,
    super.initialZoom,
    required this.centralItem,
    this.peekable = false,
  });

  @override
  State<StatefulWidget> createState() => StaticMapState();
}

class StaticMapState extends BaseMapState<StaticMap> {
  @override
  Widget buildWidget(BuildContext context) {
    final finalFiltered =
        filtered.where((item) {
          return item.key != widget.centralItem.key;
        }).toList();

    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
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
          ),
        ),

        if (mapReady)
          Positioned(
            top: 16,
            right: 16,
            bottom: 16,
            child: MapZoom(
              zoom: mapController.camera.zoom,
              minZoom: 2.0,
              maxZoom: 20.0,
              onZoomChanged: (double zoom) {
                mapController.move(mapController.camera.center, zoom);
                setState(() {});
              },
            ),
          ),
      ],
    );
  }
}
