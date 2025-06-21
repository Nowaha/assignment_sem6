import 'package:assignment_sem6/widgets/view/timeline/timeline.dart';
import 'package:flutter/material.dart';

class TimelineView extends StatelessWidget {
  final VoidCallback onMapButtonPressed;

  const TimelineView({super.key, required this.onMapButtonPressed});

  @override
  Widget build(BuildContext context) =>
      Timeline(startTimestamp: 0, endTimestamp: 1000 * 60 * 60, onMapButtonPressed: onMapButtonPressed);
}
