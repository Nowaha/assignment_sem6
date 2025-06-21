import 'dart:math';

import 'package:assignment_sem6/widgets/view/map/marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  late final List<LatLng> points;

  MapWidget({super.key}) {
    // generate random points for demonstration
    final random = Random();

    points = List.generate(10, (index) {
      return LatLng(
        41.8719 +
            random.nextDouble() * 0.1 -
            0.05, // Random latitude around Italy
        12.5674 +
            random.nextDouble() * 0.1 -
            0.05, // Random longitude around Italy
      );
    });
  }

  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<MapWidget> {
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
              widget.points.map((point) => MapMarker(point: point)).toList(),
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
