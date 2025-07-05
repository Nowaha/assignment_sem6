import 'dart:math';

import 'package:assignment_sem6/widgets/media/builder/mediabuilder.dart';
import 'package:assignment_sem6/widgets/media/video/resourcevideo.dart';
import 'package:assignment_sem6/widgets/resizable.dart';
import 'package:flutter/material.dart';

Widget videoBuilder(MediaBuilderContext c) {
  final Widget video = ResourceVideo(
    key: ValueKey(c.url),
    resourceUUID: c.url,
    resourceService: c.resourceService,
  );

  final effectiveMinWidth = max(c.minWidth, 300.0);
  final effectiveMaxWidth = (c.width).clamp(c.minWidth, c.maxWidth);
  final wrapped = ConstrainedBox(
    constraints: BoxConstraints(
      minWidth: effectiveMinWidth,
      maxHeight: effectiveMaxWidth * 9 / 16,
      maxWidth: effectiveMaxWidth,
    ),
    child: video,
  );

  if (!c.resizable) {
    return wrapped;
  }

  return Resizable(
    startingWidth: c.width,
    minWidth: effectiveMinWidth,
    maxWidth: c.maxWidth,
    onResize: (newSize) {
      final adjustedUrl = adjustUrlWidth(
        c.urlNormal,
        newSize.toInt(),
        c.width.toInt(),
      );
      c.setContents!(c.getContents!().replaceFirst(c.urlNormal, adjustedUrl));
    },
    child: wrapped,
  );
}
