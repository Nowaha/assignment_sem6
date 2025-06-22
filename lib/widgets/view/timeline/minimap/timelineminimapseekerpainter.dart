import 'package:assignment_sem6/widgets/view/timeline/minimap/seeker.dart';
import 'package:flutter/material.dart';

class TimelineMinimapSeekerPainter extends CustomPainter {
  final Hovering hovering;
  final SeekerInfo? seekerInfo;
  final Color handleBarColor;
  final Color seekerHoverColor;

  TimelineMinimapSeekerPainter({
    this.seekerInfo,
    this.hovering = Hovering.none,
    this.handleBarColor = const Color.fromARGB(255, 204, 204, 204),
    this.seekerHoverColor = const Color.fromARGB(10, 255, 255, 255),
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (seekerInfo == null) return;

    final seekerStart = seekerInfo!.seekerStartFraction * size.width;
    final seekerEnd = seekerInfo!.seekerEndFraction * size.width;

    final handleWidth = SeekerInfo.seekerHandleWidth;
    final handleHeight = SeekerInfo.seekerHandleHeight;
    final leftHandleWidth =
        hovering == Hovering.leftHandle ? handleWidth * 2 : handleWidth;
    final leftHandleHeight =
        hovering == Hovering.leftHandle ? handleHeight * 1.2 : handleHeight;
    final rightHandleWidth =
        hovering == Hovering.rightHandle ? handleWidth * 2 : handleWidth;
    final rightHandleHeight =
        hovering == Hovering.rightHandle ? handleHeight * 1.2 : handleHeight;

    bool hoveringSeeker = hovering == Hovering.seeker;
    bool hoveringAny = hovering != Hovering.none;

    final emptySpacePaint =
        Paint()
          ..color = Colors.black.withAlpha(hoveringAny ? 125 : 150)
          ..style = PaintingStyle.fill;

    final handleBarPaint =
        Paint()
          ..color = handleBarColor
          ..style = PaintingStyle.fill;

    if (hoveringSeeker) {
      final seekerBarPaint =
          Paint()
            ..color = seekerHoverColor
            ..style = PaintingStyle.fill;

      canvas.drawRect(
        Rect.fromLTWH(
          seekerStart,
          0,
          (seekerEnd - seekerStart) * size.width,
          size.height + handleHeight,
        ),
        seekerBarPaint,
      );
    }

    canvas.drawRect(
      Rect.fromLTWH(0, 0, seekerStart, size.height),
      emptySpacePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        seekerStart - leftHandleWidth / 2,
        -leftHandleHeight,
        leftHandleWidth,
        size.height + leftHandleHeight,
      ),
      handleBarPaint,
    );

    canvas.drawRect(
      Rect.fromLTWH(seekerEnd, 0, size.width - seekerEnd, size.height),
      emptySpacePaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        seekerEnd - rightHandleWidth / 2,
        -rightHandleHeight,
        rightHandleWidth,
        size.height + rightHandleHeight,
      ),
      handleBarPaint,
    );
  }

  @override
  bool shouldRepaint(TimelineMinimapSeekerPainter oldDelegate) =>
      oldDelegate.seekerInfo != seekerInfo ||
      oldDelegate.hovering != hovering ||
      oldDelegate.handleBarColor != handleBarColor ||
      oldDelegate.seekerHoverColor != seekerHoverColor;
}

enum Hovering { leftHandle, rightHandle, seeker, sides, none }
