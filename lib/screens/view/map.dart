import 'package:assignment_sem6/widgets/view/map/map.dart';
import 'package:flutter/material.dart';

class MapView extends StatelessWidget {
  final VoidCallback onTimelineButtonPressed;

  const MapView({super.key, required this.onTimelineButtonPressed});

  @override
  Widget build(BuildContext context) => Center(
    child: Stack(
      children: [
        Positioned.fill(child: MapWidget()),
        Positioned(
          right: 16,
          top: 0,
          child: Column(
            children: [
              IconButton.filled(
                onPressed: onTimelineButtonPressed,
                icon: const Icon(Icons.timeline),
                iconSize: 32,
                padding: EdgeInsets.all(16),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Text(
                "Map view is not implemented yet.",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white.withAlpha(200),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
