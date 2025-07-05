import 'package:assignment_sem6/widgets/view/map/basemap.dart';
import 'package:assignment_sem6/widgets/view/map/impl/stackmap.dart';
import 'package:assignment_sem6/widgets/view/map/marker/marker.dart';
import 'package:assignment_sem6/widgets/view/map/zoom/mapzoom.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class ZoomBarMap extends StackMap {
  final double? maxHeight;
  final Function(double)? onZoomChanged;

  const ZoomBarMap({
    super.key,
    super.initialCenter,
    super.initialZoom,
    this.maxHeight,
    this.onZoomChanged,
  });

  @override
  ZoomBarMapState createState() => ZoomBarMapState();
}

class ZoomBarMapState<T extends ZoomBarMap> extends StackMapState<T> {
  @override
  List<Widget> getStackItems(BuildContext context) => [
    if (mapReady)
      Positioned(
        top: 16,
        right: 16,
        bottom: 16,
        child: Center(
          child: SizedBox(
            height: widget.maxHeight,
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
        ),
      ),
  ];
}
