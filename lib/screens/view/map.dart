import 'package:flutter/material.dart';

class MapView extends StatelessWidget {
  final VoidCallback onTimelineButtonPressed;

  const MapView({super.key, required this.onTimelineButtonPressed});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        Text(
          "Map view is not implemented yet.",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        IconButton.filled(
          onPressed: onTimelineButtonPressed,
          icon: const Icon(Icons.timeline),
          iconSize: 32,
          padding: EdgeInsets.all(16),
        ),
      ],
    ),
  );
}
