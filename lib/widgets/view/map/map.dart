import 'package:assignment_sem6/screens/home.dart';
import 'package:assignment_sem6/widgets/view/map/marker.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  final TimelineController controller;
  final ValueNotifier<ActiveView> activeView;

  const MapWidget({
    super.key,
    required this.controller,
    required this.activeView,
  });

  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<MapWidget> {
  final List<TimelineItem> _filtered = [];

  @override
  void initState() {
    widget.controller.addListener(_filter);
    widget.activeView.addListener(_onActiveViewChanged);
    _filter();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(_filter);
    widget.activeView.removeListener(_onActiveViewChanged);
  }

  void _onActiveViewChanged() {
    final newView = widget.activeView.value;
    if (newView == ActiveView.map) {
      _filter();
    } else {
      setState(() {
        _filtered.clear();
      });
    }
  }

  void _filter() {
    if (widget.activeView.value != ActiveView.map) return;

    List<TimelineItem> newFiltered = [];

    for (final item in widget.controller.items) {
      if (item.endTimestamp <= widget.controller.visibleStartTimestamp ||
          item.startTimestamp >= widget.controller.visibleEndTimestamp) {
        continue;
      }

      newFiltered.add(item);
    }

    setState(() {
      _filtered.clear();
      _filtered.addAll(newFiltered);
    });
  }

  @override
  Widget build(BuildContext context) => FlutterMap(
    options: MapOptions(
      initialCenter: LatLng(41.8719, 12.5674), // Center the map over Italy
      initialZoom: 9.2,
      maxZoom: 20.0,
      minZoom: 2.0,
    ),
    children: [
      TileLayer(
        urlTemplate:
            "https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}.png",
        userAgentPackageName: "xyz.nowaha.assignment_sem6",
      ),
      RichAttributionWidget(
        alignment: AttributionAlignment.bottomLeft,
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            // onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
          ),
        ],
      ),
      MarkerClusterLayerWidget(
        options: MarkerClusterLayerOptions(
          maxClusterRadius: 45,
          size: const Size(40, 40),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(50),
          maxZoom: 15,
          markers:
              _filtered
                  .map(
                    (item) => MapMarker(
                      item: item,
                      visibleTimelineStart:
                          widget.controller.visibleStartTimestamp,
                      visibleTimelineEnd: widget.controller.visibleEndTimestamp,
                    ),
                  )
                  .toList(),
          builder: (context, markers) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  markers.length.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
