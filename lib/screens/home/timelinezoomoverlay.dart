import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimapzoom.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class TimelineZoomOverlay extends StatelessWidget {
  final bool showZoom;

  const TimelineZoomOverlay({super.key, required this.showZoom});

  @override
  Widget build(BuildContext context) {
    final timelineState = context.watch<TimelineState>();
    const double width = 400.0;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final int fullLength =
        timelineState.endTimestamp - timelineState.startTimestamp;
    final int visibleCenter = timelineState.visibleCenterTimestamp;
    final double fraction =
        (visibleCenter - timelineState.startTimestamp) / fullLength;
    final double left = fraction * screenWidth - 0.5 * width;
    final bool tooSmall = screenWidth - width <= 0.0;
    final double clamped =
        tooSmall ? 0.0 : left.clamp(0.0, screenWidth - width);

    return Positioned(
      bottom: 0,
      left: tooSmall ? 16.0 : clamped,
      right: tooSmall ? 16.0 : null,
      child: TimelineMinimapZoom(
        width: width,
        fullWidth: screenWidth,
        height: 90,
        visible: showZoom,
      ),
    );
  }
}
