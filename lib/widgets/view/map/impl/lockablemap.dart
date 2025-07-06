import 'package:assignment_sem6/widgets/mouse/clickhoverlistener.dart';
import 'package:assignment_sem6/widgets/view/map/impl/staticmap.dart';
import 'package:assignment_sem6/widgets/view/map/impl/zoombarmap.dart';
import 'package:assignment_sem6/widgets/view/timeline/item/timelineitem.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LockableMap extends StatefulWidget {
  final LatLng? initialCenter;
  final double? initialZoom;
  final TimelineItem centralItem;

  const LockableMap({
    super.key,
    this.initialCenter,
    this.initialZoom,
    required this.centralItem,
  });

  @override
  State<StatefulWidget> createState() => LockableMapState();
}

class LockableMapState extends State<LockableMap> {
  bool _locked = true;
  late double zoom;

  @override
  void initState() {
    super.initState();
    zoom = widget.initialZoom ?? 9.2;
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      if (!_locked)
        ZoomBarMap(
          initialCenter: widget.initialCenter,
          initialZoom: zoom,
          onZoomChanged: (newZoom) => zoom = newZoom,
        )
      else
        StaticMap(
          initialCenter: widget.initialCenter,
          initialZoom: zoom,
          centralItem: widget.centralItem,
          onZoomChanged: (newZoom) => zoom = newZoom,
        ),

      Positioned(
        left: 8,
        top: 8,
        right: 8,
        child: Center(
          child: ClickHoverListener(
            onClick:
                (_) => setState(() {
                  _locked = !_locked;
                }),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black.withAlpha(!_locked ? 150 : 255),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Icon(
                    !_locked ? Icons.lock_open_outlined : Icons.lock_outline,
                    color: Colors.white,
                  ),
                  if (_locked) Text("Unlock"),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
