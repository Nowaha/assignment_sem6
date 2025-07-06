import 'package:assignment_sem6/screens/home/home.dart';
import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/util/date.dart';
import 'package:assignment_sem6/widgets/view/map/impl/homemap.dart';
import 'package:assignment_sem6/widgets/view/timeline/painter/datespainter.dart';
import 'package:flutter/material.dart' hide Align;
import 'package:provider/provider.dart';

class MapView extends StatelessWidget {
  final VoidCallback onTimelineButtonPressed;
  final ValueNotifier<ActiveView> activeView;

  const MapView({
    super.key,
    required this.onTimelineButtonPressed,
    required this.activeView,
  });

  @override
  Widget build(BuildContext context) {
    final TimelineState timelineState = context.watch<TimelineState>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final Size size = constraints.biggest;

        return Stack(
          children: [
            Positioned.fill(child: HomeMap(activeView: activeView)),
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
              child: IgnorePointer(
                child: CustomPaint(
                  painter: DatesPainter(
                    startTimestamp: timelineState.startTimestamp,
                    endTimestamp: timelineState.endTimestamp,
                    visibleStartTimestamp: timelineState.visibleStartTimestamp,
                    visibleEndTimestamp: timelineState.visibleEndTimestamp,
                    centerTime: timelineState.visibleCenterTimestamp,
                    timescale: timelineState.visibleTimeScale,
                    surfaceColor: Colors.black,
                    onSurfaceColor: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 80,
              top: 24,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(180),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateUtil.formatIntervalShort(
                      timelineState.getTickEvery(size.width.toInt()),
                    ),
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
