import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class TimelineZoom extends StatefulWidget {
  final Function(double) zoom;
  final Function(int) pan;
  late final double dragSensitivity;
  final Widget child;

  // ignore: prefer_const_constructors_in_immutables
  TimelineZoom({
    super.key,
    required this.zoom,
    required this.pan,
    required this.dragSensitivity,
    required this.child,
  });

  TimelineZoom.calculatedSensitivity({
    super.key,
    required this.zoom,
    required this.pan,
    required double maxWidth,
    required this.child,
  }) {
    dragSensitivity = maxWidth;
  }

  @override
  State<StatefulWidget> createState() => _TimelineZoomState();
}

class _TimelineZoomState extends State<TimelineZoom>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  double _lastDragUpdate = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController.unbounded(vsync: this)
      ..addListener(() {
        final currentValue = _animationController.value;
        if (currentValue == 0) return;
        if (!currentValue.isFinite || _lastDragUpdate.isNaN) {
          _animationController.stop();
          return;
        }

        final dx = currentValue - _lastDragUpdate;
        widget.pan(-dx.toInt());
        _lastDragUpdate = currentValue;

        if (dx.abs() <= 100) {
          _animationController.stop();
        }
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _runFling(double velocity) {
    final simulation = FrictionSimulation(0.0005, 0, velocity);
    _lastDragUpdate = 0;
    _animationController.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if (pointerSignal.scrollDelta.dy != 0) {
            widget.zoom(pointerSignal.scrollDelta.dy * 0.001);
          }
          if (pointerSignal.scrollDelta.dx != 0) {
            widget.pan(
              (pointerSignal.scrollDelta.dx * widget.dragSensitivity).toInt(),
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
            widget.zoom(zoomChange);
          } else {
            widget.pan(
              (-details.focalPointDelta.dx * widget.dragSensitivity).toInt(),
            );
          }
        },
        onScaleEnd: (details) {
          final velocity =
              details.velocity.pixelsPerSecond.dx * widget.dragSensitivity;
          _runFling(velocity);
        },
        child: Container(color: Colors.transparent, child: widget.child),
      ),
    );
  }
}
