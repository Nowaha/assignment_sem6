import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TimelineZoom extends StatelessWidget {
  final double zoom;
  final Function(double) onZoomChanged;
  final int centerTime;
  final Function(int) onCenterTimeChanged;
  final double dragSensitivity;
  final Widget child;

  double get effectiveDragSensitivity => dragSensitivity / (zoom / 1.5);

  const TimelineZoom({
    super.key,
    required this.zoom,
    required this.onZoomChanged,
    required this.centerTime,
    required this.onCenterTimeChanged,
    this.dragSensitivity = 5000,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if (pointerSignal.scrollDelta.dy != 0) {
            onZoomChanged(
              (zoom - pointerSignal.scrollDelta.dy * 0.001).clamp(0.1, 10.0),
            );
          }
          if (pointerSignal.scrollDelta.dx != 0) {
            onCenterTimeChanged(
              centerTime +
                  (pointerSignal.scrollDelta.dx * effectiveDragSensitivity)
                      .toInt(),
            );
          }
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onScaleUpdate: (details) {
          onZoomChanged((zoom * details.scale).clamp(0.1, 10.0));

          if (details.scale == 1.0) {
            onCenterTimeChanged(
              centerTime -
                  (details.focalPointDelta.dx * effectiveDragSensitivity)
                      .toInt(),
            );
          }
        },
        child: Container(color: Colors.transparent, child: child),
      ),
    );
  }
}
