import 'package:assignment_sem6/widgets/view/map/impl/stackmap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SelectPointMap extends StackMap {
  final LatLng? selectedPoint;
  final Function(LatLng) onPointSelected;

  const SelectPointMap({
    super.key,
    super.initialCenter,
    super.initialZoom,
    required this.selectedPoint,
    required this.onPointSelected,
  });

  @override
  SelectPointMapState createState() => SelectPointMapState();
}

class SelectPointMapState<T extends SelectPointMap> extends StackMapState<T> {
  bool _showMarkers = true;

  @override
  void initState() {
    super.initState();
    mapController.mapEventStream.listen((event) {
      widget.onPointSelected(event.camera.center);
    });
  }

  @override
  Widget getBase() => buildMap(
    context,
    finalFiltered: _showMarkers ? filtered : [],
    staticView: true,
    extraLayers: [
      if (widget.selectedPoint != null)
        MarkerLayer(
          markers: [
            Marker(
              point: widget.selectedPoint!,
              width: 40,
              height: 40,
              child: Icon(
                Icons.circle,
                color: Colors.red.withAlpha(150),
                size: 40,
              ),
            ),
            Marker(
              point: widget.selectedPoint!,
              width: 16,
              height: 16,
              child: Icon(
                Icons.location_on,
                color: Colors.black.withAlpha(200),
                size: 16,
              ),
            ),
          ],
        ),
    ],
  );

  @override
  List<Widget> getStackExtras(BuildContext context) => [
    Positioned(
      right: 8,
      bottom: 8,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton.icon(
              label: _showMarkers ? Text("Hide") : Text("Show"),
              icon: Icon(_showMarkers ? Icons.location_on : Icons.location_off),
              onPressed: () {
                setState(() {
                  _showMarkers = !_showMarkers;
                });
              },
            ),
          ],
        ),
      ),
    ),
  ];
}
