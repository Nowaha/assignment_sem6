import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:assignment_sem6/extension/iterable.dart';
import 'package:assignment_sem6/widgets/image/postimageerrorbuilder.dart';
import 'package:assignment_sem6/widgets/image/postimageframebuilder.dart';
import 'package:assignment_sem6/widgets/image/resourceimage.dart';
import 'package:assignment_sem6/widgets/resizeable.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/widget/inlines/img.dart';

ImgBuilder postImgBuilder(
  BuildContext context, {
  double? minWidth,
  double? startingWidth,
  double? maxWidth,
}) => _imgBuilder(
  context: context,
  resizable: false,
  localResourceService: null,
  getContents: null,
  setContents: null,
  minWidth: minWidth ?? 100,
  startingWidth: startingWidth ?? 300,
  maxWidth: maxWidth ?? 600,
);

ImgBuilder editPostImgBuilder({
  required BuildContext context,
  required ResourceService localResourceService,
  required String Function() getContents,
  required Function(String contents) setContents,
  double? minWidth,
  double? startingWidth,
  double? maxWidth,
}) => _imgBuilder(
  context: context,
  resizable: true,
  localResourceService: localResourceService,
  getContents: getContents,
  setContents: setContents,
  minWidth: minWidth ?? 100,
  startingWidth: startingWidth ?? 300,
  maxWidth: maxWidth ?? 600,
);

ImgBuilder _imgBuilder({
  required BuildContext context,
  bool resizable = false,
  ResourceService? localResourceService,
  required String Function()? getContents,
  required Function(String contents)? setContents,
  double minWidth = 100,
  double startingWidth = 300,
  double maxWidth = 600,
}) => (String urlRaw, Map<String, String> attributes) {
  final urlNormal = urlRaw.replaceAll("%7C", "|");
  final split = urlNormal.split("|").map((e) => e.trim());
  final widthRaw = split.firstWhereOrNull((e) => e.startsWith("width="));
  final width =
      widthRaw != null
          ? int.tryParse(widthRaw.replaceFirst("width=", ""))
          : null;
  final url = split.first;

  final Widget image;
  if (url.startsWith("http")) {
    image = Image.network(
      url,
      fit: BoxFit.fitWidth,
      frameBuilder: postImageFrameBuilder,
      errorBuilder: postImageErrorBuilder,
    );
  } else {
    image = ResourceImage(
      key: ValueKey(url),
      resourceUUID: url,
      resourceService: localResourceService,
    );
  }

  final wrapped = InkWell(
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: (width?.toDouble() ?? startingWidth).clamp(
          minWidth,
          maxWidth,
        ),
      ),
      child: image,
    ),
    onTap:
        () => Navigator.of(context).push(
          PageRouteBuilder(
            opaque: false,
            pageBuilder: (_, __, ___) => ImageViewer(child: image),
          ),
        ),
  );
  if (!resizable) {
    return wrapped;
  }

  return Resizeable(
    startingWidth: width?.toDouble() ?? startingWidth,
    minWidth: minWidth,
    maxWidth: maxWidth,
    onResize: (newSize) {
      final adjustedUrl = _adjustWidth(urlNormal, newSize.toInt(), width);
      setContents!(getContents!().replaceFirst(urlNormal, adjustedUrl));
    },
    child: wrapped,
  );
};

String _adjustWidth(String url, int newWidth, int? currentWidth) {
  if (currentWidth == null) return "$url|width=$newWidth";
  if (currentWidth == newWidth) return url;
  return url.replaceFirst(RegExp(r"\|width=\d+(\.\d+)?"), "|width=$newWidth");
}
