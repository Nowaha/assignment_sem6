import 'package:assignment_sem6/screens/home/home.dart';
import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/widgets/view/map/zoom/mapzoom.dart';
import 'package:assignment_sem6/widgets/view/map/marker.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class MapWidget extends StatefulWidget {
  final LatLng initialCenter;
  final double initialZoom;
  final bool staticView;
  final String? staticItemKey;
  final ValueNotifier<ActiveView>? activeView;

  const MapWidget({
    super.key,
    this.initialCenter = const LatLng(
      41.8719,
      12.5674,
    ), // Center the map over Italy
    this.initialZoom = 9.2,
    this.staticView = false,
    this.staticItemKey,
    this.activeView,
  });

  const MapWidget.static({
    Key? key,
    LatLng initialCenter = const LatLng(
      41.8719,
      12.5674,
    ), // Center the map over Italy
    double initialZoom = 9.2,
    required String staticItemKey,
  }) : this(
         key: key,
         initialCenter: initialCenter,
         initialZoom: initialZoom,
         staticView: true,
         staticItemKey: staticItemKey,
       );

  @override
  State<StatefulWidget> createState() => _MapState();
}

class _MapState extends State<MapWidget> {
  late final TimelineState _timelineState;
  late final MapController _mapController;
  final List<TimelineItem> _filtered = [];

  bool _mapReady = false;

  @override
  void initState() {
    _mapController = MapController();
    _timelineState = context.read<TimelineState>();
    _timelineState.addListener(_filter);
    widget.activeView?.addListener(_onActiveViewChanged);
    _filter();

    super.initState();
  }

  @override
  void dispose() {
    _timelineState.removeListener(_filter);
    widget.activeView?.removeListener(_onActiveViewChanged);

    super.dispose();
  }

  void _onActiveViewChanged() {
    final newView = widget.activeView?.value;
    if (newView == ActiveView.map) {
      _filter();
    } else {
      setState(() {
        _filtered.clear();
      });
    }
  }

  void _filter() {
    if (widget.activeView != null && widget.activeView!.value != ActiveView.map)
      return;

    List<TimelineItem> newFiltered = [];

    for (final item in _timelineState.items) {
      if (item.endTimestamp <= _timelineState.visibleStartTimestamp ||
          item.startTimestamp >= _timelineState.visibleEndTimestamp) {
        continue;
      }

      newFiltered.add(item);
    }

    setState(() {
      _filtered.clear();
      _filtered.addAll(newFiltered);
    });
  }

  MapMarker _buildMarker(TimelineItem item) => MapMarker(
    item: item,
    staticView: widget.staticView,
    visibleTimelineStart: _timelineState.visibleStartTimestamp,
    visibleTimelineEnd: _timelineState.visibleEndTimestamp,
  );

  @override
  Widget build(BuildContext context) {
    if (!_mapReady) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _mapReady = true;
        });
      });
    }

    final TimelineItem? staticItem =
        widget.staticItemKey != null
            ? _timelineState.itemsMap[widget.staticItemKey!]
            : null;

    final filtered =
        _filtered.where((item) {
          if (widget.staticView) {
            return item.key != widget.staticItemKey;
          }
          return true;
        }).toList();

    return Stack(
      children: [
        IgnorePointer(
          ignoring: widget.staticView,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: widget.initialCenter,
              initialZoom: widget.initialZoom,
              maxZoom: 20.0,
              minZoom: 2.0,
            ),
            mapController: _mapController,
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
                  markers: filtered.map(_buildMarker).toList(),
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

              if (staticItem != null)
                MarkerLayer(markers: [_buildMarker(staticItem)]),
            ],
          ),
        ),

        if (_mapReady && widget.staticView)
          Positioned(
            top: 16,
            right: 16,
            bottom: 16,
            child: MapZoom(
              zoom: _mapController.camera.zoom,
              minZoom: 2.0,
              maxZoom: 20.0,
              onZoomChanged: (double zoom) {
                _mapController.move(_mapController.camera.center, zoom);
                setState(() {});
              },
            ),
          ),
      ],
    );
  }
}
