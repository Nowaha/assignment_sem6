import 'package:assignment_sem6/screens/home.dart';
import 'package:assignment_sem6/widgets/view/map/map.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter/material.dart';

class MapView extends StatelessWidget {
  final TimelineController controller;
  final VoidCallback onTimelineButtonPressed;
  final ValueNotifier<ActiveView> activeView;

  const MapView({
    super.key,
    required this.controller,
    required this.onTimelineButtonPressed,
    required this.activeView,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Stack(
      children: [
        Positioned.fill(
          child: MapWidget(controller: controller, activeView: activeView),
        ),
        Positioned(
          right: 16,
          top: 16,
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
      ],
    ),
  );
}
