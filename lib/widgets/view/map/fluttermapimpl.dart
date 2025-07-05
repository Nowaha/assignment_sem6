import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/widgets/view/map/marker/marker.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class FlutterMapImpl extends StatefulWidget {
  final List<TimelineItem> items;
  final LatLng initialCenter;
  final double initialZoom;
  final MapController? mapController;
  final bool staticView;
  final List<Widget> extraLayers;
  final int? startTimestamp;
  final int? endTimestamp;

  const FlutterMapImpl({
    super.key,
    required this.items,
    required this.initialCenter,
    required this.initialZoom,
    this.mapController,
    this.staticView = false,
    this.extraLayers = const [],
    this.startTimestamp,
    this.endTimestamp,
  });

  @override
  State<FlutterMapImpl> createState() => _FlutterMapImplState();
}

class _FlutterMapImplState extends State<FlutterMapImpl> {
  late final TimelineState _timelineState;

  @override
  void initState() {
    _timelineState = context.read<TimelineState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => FlutterMap(
    options: MapOptions(
      initialCenter: widget.initialCenter,
      initialZoom: widget.initialZoom,
      maxZoom: 20.0,
      minZoom: 2.0,
    ),
    mapController: widget.mapController,
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
          maxClusterRadius: 100,
          size: const Size(40, 40),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(50),
          maxZoom: 15,
          rotate: true,
          markers:
              widget.items
                  .map(
                    (item) => MapMarker(
                      item: item,
                      visibleTimelineStart:
                          widget.startTimestamp ??
                          _timelineState.visibleStartTimestamp,
                      visibleTimelineEnd:
                          widget.endTimestamp ??
                          _timelineState.visibleEndTimestamp,
                      staticView: widget.staticView,
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
      ...widget.extraLayers,
    ],
  );
}
