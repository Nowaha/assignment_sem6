import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TimelineZoom extends StatelessWidget {
  final Function(double) zoom;
  final Function(int) pan;
  final double dragSensitivity;
  final Widget child;

  double get effectiveDragSensitivity => dragSensitivity;

  const TimelineZoom({
    super.key,
    required this.zoom,
    required this.pan,
    this.dragSensitivity = 5000,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if (pointerSignal.scrollDelta.dy != 0) {
            zoom(pointerSignal.scrollDelta.dy * 0.001);
          }
          if (pointerSignal.scrollDelta.dx != 0) {
            pan(
              (pointerSignal.scrollDelta.dx * effectiveDragSensitivity).toInt(),
            );
          }
        }
      },
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onScaleUpdate: (details) {
          if (details.scale != 1.0) {
            final scaleDelta = details.scale - 1.0;
            final zoomChange = 1 + scaleDelta * 0.2;
            zoom(zoomChange);
          } else {
            pan(
              (-details.focalPointDelta.dx * effectiveDragSensitivity).toInt(),
            );
          }
        },
        child: Container(color: Colors.transparent, child: child),
      ),
    );
  }
}
