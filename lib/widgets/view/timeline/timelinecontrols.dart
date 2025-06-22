import 'package:assignment_sem6/widgets/collapsible/collapsiblecontainer.dart';
import 'package:flutter/material.dart';

class TimelineControls extends StatelessWidget {
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onResetZoom;
  final VoidCallback onScrollLeft;
  final VoidCallback onScrollRight;
  final VoidCallback onScrollUp;
  final VoidCallback onScrollDown;
  final VoidCallback onCenter;

  const TimelineControls({
    super.key,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onResetZoom,
    required this.onScrollLeft,
    required this.onScrollRight,
    required this.onScrollUp,
    required this.onScrollDown,
    required this.onCenter,
  });

  @override
  Widget build(BuildContext context) => RepaintBoundary(
    child: CollapsibleContainer(
      title: "Controls",
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            children: [
              IconButton.filled(
                tooltip: "Zoom in",
                onPressed: onZoomIn,
                icon: const Icon(Icons.zoom_in),
              ),
              IconButton.filled(
                tooltip: "Zoom out",
                onPressed: onZoomOut,
                icon: const Icon(Icons.zoom_out),
              ),
              SizedBox.shrink(),
              IconButton.filled(
                tooltip: "Reset zoom",
                onPressed: onResetZoom,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              IconButton.filled(
                tooltip: "Scroll to the left",
                onPressed: onScrollLeft,
                icon: const Icon(Icons.arrow_left),
              ),
              IconButton.filled(
                tooltip: "Scroll to the right",
                onPressed: onScrollRight,
                icon: const Icon(Icons.arrow_right),
              ),
              SizedBox.shrink(),
              IconButton.filled(
                tooltip: "Center",
                onPressed: onCenter,
                icon: const Icon(Icons.center_focus_strong),
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              IconButton.filled(
                tooltip: "Scroll up",
                onPressed: onScrollUp,
                icon: const Icon(Icons.arrow_upward),
              ),
              IconButton.filled(
                tooltip: "Scroll down",
                onPressed: onScrollDown,
                icon: const Icon(Icons.arrow_downward),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
