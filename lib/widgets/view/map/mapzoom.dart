import 'package:assignment_sem6/util/platform.dart';
import 'package:flutter/material.dart';

class MapZoom extends StatefulWidget {
  final double zoom;
  final double minZoom;
  final double maxZoom;
  final Function(double) onZoomChanged;

  const MapZoom({
    super.key,
    required this.zoom,
    required this.minZoom,
    required this.maxZoom,
    required this.onZoomChanged,
  });

  @override
  State<MapZoom> createState() => _MapZoomState();
}

class _MapZoomState extends State<MapZoom> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter:
        (_) => setState(() {
          _hovered = true;
        }),
    onExit:
        (_) => setState(() {
          _hovered = false;
        }),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(
          _hovered || PlatformUtil.isMobile ? 200 : 150,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        spacing: 8,
        children: [
          Icon(
            Icons.zoom_in,
            size: 24,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderTheme.of(context),
                child: Slider(
                  value: widget.zoom,
                  min: widget.minZoom,
                  max: widget.maxZoom,
                  label: widget.zoom.toStringAsFixed(1),
                  padding: EdgeInsets.all(8.0),
                  onChanged: (value) {
                    widget.onZoomChanged(value);
                  },
                ),
              ),
            ),
          ),
          Icon(
            Icons.zoom_out,
            size: 24,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black, blurRadius: 4)],
          ),
        ],
      ),
    ),
  );
}
