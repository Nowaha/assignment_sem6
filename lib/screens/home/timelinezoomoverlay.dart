import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimapzoom.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:flutter/widgets.dart';

class TimelineZoomOverlay extends StatelessWidget {
  final TimelineController timelineController;
  final bool showZoom;

  const TimelineZoomOverlay({
    super.key,
    required this.timelineController,
    required this.showZoom,
  });

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: timelineController,
    builder: (context, _) {
      const double width = 400.0;
      final screenWidth = MediaQuery.sizeOf(context).width;
      final int fullLength =
          timelineController.endTimestamp - timelineController.startTimestamp;
      final int visibleCenter = timelineController.visibleCenterTimestamp;
      final double fraction =
          (visibleCenter - timelineController.startTimestamp) / fullLength;
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
          controller: timelineController,
          visible: showZoom,
        ),
      );
    },
  );
}
