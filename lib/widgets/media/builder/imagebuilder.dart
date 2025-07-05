import 'package:assignment_sem6/widgets/media/builder/mediabuilder.dart';
import 'package:assignment_sem6/widgets/media/image/resourceimage.dart';
import 'package:assignment_sem6/widgets/resizable.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/inlines/img.dart';

Widget imageBuilder(MediaBuilderContext c) {
  final Widget image = ResourceImage(
    key: ValueKey(c.url),
    resourceUUID: c.url,
    resourceService: c.resourceService,
  );

  final wrapped = InkWell(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (c.width).clamp(c.minWidth, c.maxWidth),
      ),
      child: image,
    ),
    onTap:
        () => Navigator.of(c.buildContext).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => ImageViewer(child: image),
          ),
        ),
  );

  if (!c.resizable) {
    return wrapped;
  }

  return Resizable(
    startingWidth: c.width,
    minWidth: c.minWidth,
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
