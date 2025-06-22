import 'package:assignment_sem6/widgets/view/timeline/timeline.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter/material.dart';

class TimelineView extends StatefulWidget {
  final TimelineController controller;
  final VoidCallback onMapButtonPressed;

  const TimelineView({
    super.key,
    required this.controller,
    required this.onMapButtonPressed,
  });

  @override
  State<StatefulWidget> createState() => _TimelineViewState();
}

class _TimelineViewState extends State<TimelineView> {
  @override
  Widget build(BuildContext context) {
    return Timeline(
      controller: widget.controller,
      onMapButtonPressed: widget.onMapButtonPressed,
    );
  }
}
