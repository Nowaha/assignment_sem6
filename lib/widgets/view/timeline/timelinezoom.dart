import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

typedef ShouldDelegateScaleUpdate = bool Function(ScaleUpdateDetails details);
typedef OnDelegateScaleUpdate = void Function(ScaleUpdateDetails details);
typedef OnDelegateRelease = void Function(ScaleEndDetails details);

class TimelineZoom extends StatefulWidget {
  final Function(double) zoom;
  final Function(int) pan;
  final double dragSensitivity;
  final Widget child;
  final bool invertGesturePan;
  final bool invertGestureZoom;

  final ShouldDelegateScaleUpdate? shouldDelegateScaleUpdate;
  final OnDelegateScaleUpdate? onDelegateScaleUpdate;
  final OnDelegateRelease? onDelegateRelease;

  const TimelineZoom({
    super.key,
    required this.zoom,
    required this.pan,
    required this.dragSensitivity,
    required this.child,
    this.invertGesturePan = false,
    this.invertGestureZoom = false,
  }) : shouldDelegateScaleUpdate = null,
       onDelegateScaleUpdate = null,
       onDelegateRelease = null;

  const TimelineZoom.delegate({
    super.key,
    required this.zoom,
    required this.pan,
    required this.dragSensitivity,
    required this.child,
    required this.shouldDelegateScaleUpdate,
    required this.onDelegateScaleUpdate,
    required this.onDelegateRelease,
    this.invertGesturePan = false,
    this.invertGestureZoom = false,
  });

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

  bool _delegated = false;
  bool _pointerDown = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if (pointerSignal.scrollDelta.dy != 0) {
            if (pointerSignal.scrollDelta.dy < 0) {
              widget.zoom(1.1);
            } else {
              widget.zoom(0.9);
            }
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
            widget.zoom(widget.invertGestureZoom ? 1 / zoomChange : zoomChange);
          } else {
            if (details.pointerCount == 1 && !_pointerDown) {
              if (_delegated ||
                  widget.shouldDelegateScaleUpdate != null &&
                      widget.shouldDelegateScaleUpdate!(details)) {
                _delegated = true;
                widget.onDelegateScaleUpdate?.call(details);
                return;
              }
            }

            _pointerDown = true;

            widget.pan(
              (-details.focalPointDelta.dx * widget.dragSensitivity).toInt(),
            );
          }
        },
        onScaleEnd: (details) {
          _pointerDown = false;

          if (_delegated) {
            _delegated = false;
            widget.onDelegateRelease?.call(details);
            return;
          }

          final velocity =
              details.velocity.pixelsPerSecond.dx * widget.dragSensitivity;
          _runFling(velocity);
        },
        child: Container(color: Colors.transparent, child: widget.child),
      ),
    );
  }
}
