import 'package:assignment_sem6/widgets/view/timeline/timeline.dart';
import 'package:flutter/material.dart';

class TimelineView extends StatelessWidget {
  final VoidCallback onMapButtonPressed;
  final VoidCallback expandLeft;
  final VoidCallback expandRight;

  const TimelineView({
    super.key,
    required this.onMapButtonPressed,
    required this.expandLeft,
    required this.expandRight,
  });

  @override
  Widget build(BuildContext context) => Timeline(
    onMapButtonPressed: onMapButtonPressed,
    expandLeft: expandLeft,
    expandRight: expandRight,
  );
}
