import 'package:flutter/material.dart';

class MapZoomText extends StatelessWidget {
  final double zoom;
  final double minZoom;
  final double maxZoom;

  late final double zoomPercentage;

  MapZoomText({
    super.key,
    required this.zoom,
    required this.minZoom,
    required this.maxZoom,
  }) {
    zoomPercentage = (((zoom - minZoom) / (maxZoom - minZoom)) * 100);
  }

  @override
  Widget build(BuildContext context) => Text(
    "${zoomPercentage.toStringAsFixed(0)}%",
    style: TextStyle(color: Colors.white, fontSize: 12),
  );
}
