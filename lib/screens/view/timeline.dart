import 'package:flutter/material.dart';

class TimelineView extends StatelessWidget {
  final VoidCallback onMapButtonPressed;

  const TimelineView({super.key, required this.onMapButtonPressed});

  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 16,
      children: [
        Text(
          "Timeline view is not implemented yet.",
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        IconButton.filled(
          onPressed: onMapButtonPressed,
          icon: const Icon(Icons.map),
          iconSize: 32,
          padding: EdgeInsets.all(16),
        ),
      ],
    ),
  );
}
