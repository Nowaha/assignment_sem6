import 'package:assignment_sem6/widgets/view/timeline/minimap/seeker.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimappostpainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimapseekerpainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinecontroller.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinezoom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimelineMiniMap extends StatefulWidget {
  final TimelineController controller;
  final double height;

  const TimelineMiniMap({
    super.key,
    required this.controller,
    this.height = 90.0,
  });

  @override
  State<StatefulWidget> createState() => _TimelineMiniMapState();
}

class _TimelineMiniMapState extends State<TimelineMiniMap> {
  static const _leniency = 4.0;
  SeekerInfo? _seekerInfo;
  Hovering _hovering = Hovering.none;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() {
      _updateSeekerInfo();
    });
  }

  void _updateSeekerInfo() {
    final controller = widget.controller;
    if (controller.visibleStartTimestamp == controller.visibleEndTimestamp) {
      setState(() {
        _seekerInfo = SeekerInfo.zero();
      });
      return;
    }

    final seekerStart =
        (controller.visibleStartTimestamp -
            controller.effectiveStartTimestamp) /
        (controller.effectiveEndTimestamp - controller.effectiveStartTimestamp);

    final seekerEnd =
        (controller.visibleEndTimestamp - controller.effectiveStartTimestamp) /
        (controller.effectiveEndTimestamp - controller.effectiveStartTimestamp);

    _setSeekerInfo(
      SeekerInfo(
        seekerStartFraction: seekerStart,
        seekerEndFraction: seekerEnd,
      ),
    );
  }

  void _setSeekerInfo(SeekerInfo? seekerInfo) {
    if (_seekerInfo != seekerInfo) {
      setState(() {
        _seekerInfo = seekerInfo;
      });
    }
  }

  void _onHover(double width, double x) {
    if (_seekerInfo == null) return;

    final Hovering newHovering;
    if (_seekerInfo!.isWithinLeftHandle(width, x, _leniency)) {
      newHovering = Hovering.leftHandle;
    } else if (_seekerInfo!.isWithinRightHandle(width, x, _leniency)) {
      newHovering = Hovering.rightHandle;
    } else if (_seekerInfo!.isWithinSeeker(width, x)) {
      newHovering = Hovering.seeker;
    } else {
      newHovering = Hovering.sides;
    }

    if (_hovering != newHovering) {
      setState(() {
        _hovering = newHovering;
      });
    }
  }

  void _onExit(PointerExitEvent event) {
    if (_hovering != Hovering.none) {
      setState(() {
        _hovering = Hovering.none;
      });
    }
  }

  void _onDragLeft(double dx) {
    if (_seekerInfo == null) return;
    widget.controller.adjustVisibleStart(dx.toInt());
    setState(() {
      _hovering = Hovering.leftHandle;
    });
  }

  void _onDragRight(double dx) {
    if (_seekerInfo == null) return;
    widget.controller.adjustVisibleEnd(dx.toInt());
    setState(() {
      _hovering = Hovering.rightHandle;
    });
  }

  void _onClickOutside(double x) {}

  bool _draggingLeftHandle = false;
  bool _draggingRightHandle = false;

  @override
  Widget build(BuildContext context) {
    if (_seekerInfo == null) {
      _updateSeekerInfo();
    }

    double width = MediaQuery.sizeOf(context).width;

    double dragSensitivity =
        (widget.controller.endTimestamp - widget.controller.startTimestamp) /
        width;

    return TimelineZoom.delegate(
      dragSensitivity: dragSensitivity,
      shouldDelegateScaleUpdate: (details) {
        if (_seekerInfo == null) return false;

        final x = details.localFocalPoint.dx;
        return _seekerInfo!.isWithinLeftHandle(width, x, _leniency) ||
            _seekerInfo!.isWithinRightHandle(width, x, _leniency);
      },
      onDelegateScaleUpdate: (details) {
        final x = details.localFocalPoint.dx;
        final dx = details.focalPointDelta.dx * dragSensitivity;

        if (_draggingLeftHandle ||
            _seekerInfo?.isWithinLeftHandle(width, x, _leniency) == true) {
          _draggingLeftHandle = true;
          _onDragLeft(dx);
        } else if (_draggingRightHandle ||
            _seekerInfo?.isWithinRightHandle(width, x, _leniency) == true) {
          _draggingRightHandle = true;
          _onDragRight(dx);
        } else {
          _onClickOutside(x);
        }
      },
      onDelegateRelease: (_) {
        setState(() {
          _draggingLeftHandle = false;
          _draggingRightHandle = false;
        });
      },
      invertGestureZoom: true,
      zoom: widget.controller.zoom,
      pan: (pan) {
        widget.controller.pan(-pan);
      },
      panUp: (_) {},
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withAlpha(200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(126),
              blurRadius: 8.0,
              offset: const Offset(0, -2),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: Theme.of(context).colorScheme.outline,
              width: 2.0,
            ),
          ),
        ),
        child: MouseRegion(
          onEnter: (event) => _onHover(width, event.localPosition.dx),
          onExit: _onExit,
          onHover: (event) => _onHover(width, event.localPosition.dx),
          cursor: switch (_hovering) {
            Hovering.leftHandle => SystemMouseCursors.resizeLeft,
            Hovering.rightHandle => SystemMouseCursors.resizeRight,
            Hovering.seeker => SystemMouseCursors.click,
            _ => SystemMouseCursors.basic,
          },
          child: CustomPaint(
            painter: TimelineMinimapPostPainter(
              widget.controller,
              timelineColor: Theme.of(context).colorScheme.onSurface,
            ),
            foregroundPainter: TimelineMinimapSeekerPainter(
              seekerInfo: _seekerInfo,

              hovering: _hovering,
            ),
          ),
        ),
      ),
    );
  }
}
