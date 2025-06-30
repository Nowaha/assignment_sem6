import 'package:assignment_sem6/screens/home.dart';
import 'package:assignment_sem6/widgets/view/map/map.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/datespainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/scalepainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter/material.dart' hide Align;

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
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final Size size = constraints.biggest;

      return Stack(
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
                  iconSize: 24,
                  padding: EdgeInsets.all(12),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: ListenableBuilder(
              listenable: controller,
              builder:
                  (context, _) => IgnorePointer(
                    child: CustomPaint(
                      painter: DatesPainter(
                        startTimestamp: controller.startTimestamp,
                        endTimestamp: controller.endTimestamp,
                        visibleStartTimestamp: controller.visibleStartTimestamp,
                        visibleEndTimestamp: controller.visibleEndTimestamp,
                        centerTime: controller.visibleCenterTimestamp,
                        timescale: controller.visibleTimeScale,
                        surfaceColor: Colors.black,
                        onSurfaceColor: Colors.white,
                      ),
                    ),
                  ),
            ),
          ),
          Positioned(
            child: ListenableBuilder(
              listenable: controller,
              builder:
                  (context, _) => IgnorePointer(
                    child: CustomPaint(
                      painter: ScalePainter(
                        position: Offset(size.width - 80, 40),
                        timelineWidth: 200,
                        timelineThickness: 2,
                        scaleDownFactor: 1,
                        timeScale: controller.visibleTimeScale,
                        tickEvery: controller.getTickEvery(size.width.toInt()),
                        visibleStartTimestamp: controller.visibleStartTimestamp,
                        timelineColor: Colors.white,
                        surfaceColor: Colors.black,
                        align: Align.right,
                      ),
                    ),
                  ),
            ),
          ),
        ],
      );
    },
  );
}
