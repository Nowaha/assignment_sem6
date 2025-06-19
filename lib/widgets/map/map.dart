import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

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
    ],
  );
}
