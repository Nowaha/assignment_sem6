import 'package:assignment_sem6/state/timelinestate.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/seeker.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimappostpainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/minimap/timelineminimapseekerpainter.dart';
import 'package:assignment_sem6/widgets/view/timeline/timelinezoom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TimelineMiniMap extends StatefulWidget {
  final double height;
  final Function(bool show)? setShowZoom;

  const TimelineMiniMap({super.key, this.height = 90.0, this.setShowZoom});

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

    final timelineState = context.read<TimelineState>();
    timelineState.addListener(() {
      _updateSeekerInfo();
    });
  }

  void _updateSeekerInfo() {
    final timelineState = context.read<TimelineState>();
    if (timelineState.visibleStartTimestamp ==
        timelineState.visibleEndTimestamp) {
      setState(() {
        _seekerInfo = SeekerInfo.zero();
      });
      return;
    }

    final seekerStart =
        (timelineState.visibleStartTimestamp - timelineState.startTimestamp) /
        (timelineState.endTimestamp - timelineState.startTimestamp);

    final seekerEnd =
        (timelineState.visibleEndTimestamp - timelineState.startTimestamp) /
        (timelineState.endTimestamp - timelineState.startTimestamp);

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

    if (newHovering != Hovering.none) {
      widget.setShowZoom?.call(true);
    } else {
      widget.setShowZoom?.call(false);
    }

    if (_hovering != newHovering) {
      setState(() {
        _hovering = newHovering;
      });
    }
  }

  void _onExit(PointerExitEvent event) {
    if (_hovering != Hovering.none) {
      widget.setShowZoom?.call(false);
      setState(() {
        _hovering = Hovering.none;
      });
    }
  }

  void _onDragLeft(double dx) {
    if (_seekerInfo == null) return;

    final timelineState = context.read<TimelineState>();
    timelineState.adjustVisibleStart(dx.toInt());
    setState(() {
      _hovering = Hovering.leftHandle;
    });
  }

  void _onDragRight(double dx) {
    if (_seekerInfo == null) return;

    final timelineState = context.read<TimelineState>();
    timelineState.adjustVisibleEnd(dx.toInt());
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

    final timelineState = context.watch<TimelineState>();

    double width = MediaQuery.sizeOf(context).width;

    double dragSensitivity =
        (timelineState.endTimestamp - timelineState.startTimestamp) / width;

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
      zoom: timelineState.zoom,
      pan: (pan) {
        timelineState.pan(-pan);
        widget.setShowZoom?.call(true);
      },
      panEnd: () {
        widget.setShowZoom?.call(false);
      },
      panUp: (_) {},
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
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
              items: timelineState.items,
              selectedItemKey: timelineState.selectedItem.value,
              startTimestamp: timelineState.startTimestamp,
              endTimestamp: timelineState.endTimestamp,
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
