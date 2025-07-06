import 'package:assignment_sem6/widgets/view/map/impl/stackmap.dart';
import 'package:assignment_sem6/widgets/view/map/zoom/mapzoom.dart';
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
  void initState() {
    super.initState();
    mapController.mapEventStream.listen((event) {
      if (event is MapEventWithMove) {
        if (event.oldCamera.zoom != event.camera.zoom) {
          onZoomChange(event.camera.zoom);
        }
      }
    });
  }

  void onZoomChange(double zoom) {
    setState(() {});
    widget.onZoomChanged?.call(zoom);
  }

  @override
  Widget getBase() => buildMap(context, finalFiltered: filtered);

  @override
  List<Widget> getStackExtras(BuildContext context) => [
    if (mapReady)
      Positioned(
        top: 8,
        right: 8,
        bottom: 8,
        child: Center(
          child: SizedBox(
            height: widget.maxHeight,
            child: MapZoom(
              zoom: mapController.camera.zoom,
              minZoom: 2.0,
              maxZoom: 20.0,
              onZoomChanged: (double zoom) {
                mapController.move(mapController.camera.center, zoom);
                onZoomChange(zoom);
              },
            ),
          ),
        ),
      ),
  ];
}
