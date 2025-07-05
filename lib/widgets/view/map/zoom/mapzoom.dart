import 'package:assignment_sem6/util/platform.dart';
import 'package:assignment_sem6/widgets/view/map/zoom/mapzoomtext.dart';
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
      padding: EdgeInsets.only(left: 2.0, right: 2.0, top: 2.0, bottom: 14.0),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(
          _hovered || PlatformUtil.isMobile ? 200 : 150,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          IconButton(
            onPressed: () {
              widget.onZoomChanged(
                (widget.zoom * 1.1).clamp(widget.minZoom, widget.maxZoom),
              );
            },
            constraints: BoxConstraints(),
            iconSize: 24,
            icon: Icon(
              Icons.zoom_in,
              size: 24,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),

          SizedBox(height: 8.0),

          Expanded(
            child: RotatedBox(
              quarterTurns: 3,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4.0,
                  thumbShape: RoundSliderThumbShape(
                    enabledThumbRadius: 8.0,
                    pressedElevation: 4.0,
                  ),
                  inactiveTrackColor: Colors.white.withAlpha(100),
                ),
                child: Slider(
                  value: widget.zoom,
                  min: widget.minZoom,
                  max: widget.maxZoom,
                  label: widget.zoom.toStringAsFixed(1),
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  onChanged: (value) {
                    widget.onZoomChanged(value);
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: 8.0),

          IconButton(
            onPressed: () {
              widget.onZoomChanged(
                (widget.zoom * 0.9).clamp(widget.minZoom, widget.maxZoom),
              );
            },
            constraints: BoxConstraints(),
            iconSize: 24,
            icon: Icon(
              Icons.zoom_out,
              size: 24,
              color: Colors.white,
              shadows: [Shadow(color: Colors.black, blurRadius: 4)],
            ),
          ),

          MapZoomText(
            zoom: widget.zoom,
            minZoom: widget.minZoom,
            maxZoom: widget.maxZoom,
          ),
        ],
      ),
    ),
  );
}
