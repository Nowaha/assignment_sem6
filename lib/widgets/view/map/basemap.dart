import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/widgets/view/map/fluttermapimpl.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class BaseMapWidget extends StatefulWidget {
  final LatLng initialCenter;
  final double initialZoom;

  const BaseMapWidget({super.key, LatLng? initialCenter, double? initialZoom})
    : initialCenter =
          initialCenter ??
          const LatLng(41.8719, 12.5674), // Center the map over Italy
      initialZoom = initialZoom ?? 9.2;

  @override
  State<StatefulWidget> createState() => BaseMapState<BaseMapWidget>();
}

class BaseMapState<T extends BaseMapWidget> extends State<T> {
  late final TimelineState timelineState;
  late final MapController mapController;
  final List<TimelineItem> filtered = [];

  int get startTimestamp => timelineState.visibleStartTimestamp;
  int get endTimestamp => timelineState.visibleEndTimestamp;

  bool mapReady = false;

  @override
  void initState() {
    mapController = MapController();
    timelineState = context.read<TimelineState>();
    timelineState.addListener(filter);
    filter();

    super.initState();
  }

  @override
  void dispose() {
    timelineState.removeListener(filter);

    super.dispose();
  }

  void filter() {
    List<TimelineItem> newFiltered = [];

    for (final item in timelineState.items) {
      if (item.endTimestamp <= startTimestamp ||
          item.startTimestamp >= endTimestamp) {
        continue;
      }

      newFiltered.add(item);
    }

    setState(() {
      filtered.clear();
      filtered.addAll(newFiltered);
    });
  }

  Widget buildWidget(BuildContext context) =>
      buildMap(context, finalFiltered: filtered);

  Widget buildMap(
    BuildContext context, {
    required List<TimelineItem> finalFiltered,
    List<Widget> extraLayers = const [],
    bool staticView = false,
  }) => FlutterMapImpl(
    items: finalFiltered,
    initialCenter: widget.initialCenter,
    initialZoom: widget.initialZoom,
    mapController: mapController,
    staticView: staticView,
    extraLayers: extraLayers,
    startTimestamp: startTimestamp,
    endTimestamp: endTimestamp,
  );

  void setMapReadyNextFrame() {
    if (mapReady) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        mapReady = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setMapReadyNextFrame();
    return buildWidget(context);
  }
}
