import 'package:assignment_sem6/widgets/view/timeline/timeline.dart';
import 'package:flutter/material.dart';

class TimelineView extends StatelessWidget {
  final VoidCallback onMapButtonPressed;

  const TimelineView({super.key, required this.onMapButtonPressed});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: Timeline(startTimestamp: 0, endTimestamp: 1000 * 60 * 60),
      ),
      Positioned(
        right: 16,
        top: 0,
        child: Column(
          children: [
            IconButton.filled(
              onPressed: onMapButtonPressed,
              icon: const Icon(Icons.map),
              iconSize: 32,
              padding: EdgeInsets.all(16),
            ),
          ],
        ),
      ),
      // Positioned.fill(
      //   child: IgnorePointer(
      //     child: Center(
      //       child: Text(
      //         "Timeline view is not implemented yet.",
      //         style: Theme.of(context).textTheme.headlineSmall,
      //       ),
      //     ),
      //   ),
      // ),
    ],
  );
}
