import 'package:assignment_sem6/config/builder/imagebuilder.dart';
import 'package:assignment_sem6/config/builder/videobuilder.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:assignment_sem6/extension/iterable.dart';
import 'package:assignment_sem6/widgets/image/mediaerror.dart';
import 'package:flutter/material.dart';

MediaBuilder postMediaBuilder(
  BuildContext context, {
  double? minWidth,
  double? startingWidth,
  double? maxWidth,
}) => _mediaBuilder(
  buildContext: context,
  resizable: false,
  resourceService: null,
  getContents: null,
  setContents: null,
  minWidth: minWidth ?? 100,
  startingWidth: startingWidth ?? 300,
  maxWidth: maxWidth ?? 600,
);

MediaBuilder editPostMediaBuilder({
  required BuildContext context,
  required ResourceService localResourceService,
  required String Function() getContents,
  required Function(String contents) setContents,
  double? minWidth,
  double? startingWidth,
  double? maxWidth,
}) => _mediaBuilder(
  buildContext: context,
  resizable: true,
  resourceService: localResourceService,
  getContents: getContents,
  setContents: setContents,
  minWidth: minWidth ?? 100,
  startingWidth: startingWidth ?? 300,
  maxWidth: maxWidth ?? 600,
);

MediaBuilder _mediaBuilder({
  required BuildContext buildContext,
  bool resizable = false,
  ResourceService? resourceService,
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
  final mediaType = split.first.split(":").first.toLowerCase();
  final url = split.first.split("$mediaType:").last;

  final context = MediaBuilderContext(
    buildContext: buildContext,
    url: url,
    urlNormal: urlNormal,
    resourceService: resourceService,
    getContents: getContents,
    setContents: setContents,
    width: width?.toDouble() ?? startingWidth,
    minWidth: minWidth,
    startingWidth: startingWidth,
    maxWidth: maxWidth,
    resizable: resizable,
  );

  return switch (mediaType.toLowerCase()) {
    "image" || "img" => imageBuilder(context),
    "video" || "vid" => videoBuilder(context),
    _ => MediaError(message: "Unknown media type: $mediaType"),
  };
};

String adjustUrlWidth(String url, int newWidth, int? currentWidth) {
  if (currentWidth == null) return "$url|width=$newWidth";
  if (currentWidth == newWidth) return url;
  return url.replaceFirst(RegExp(r"\|width=\d+(\.\d+)?"), "|width=$newWidth");
}

class MediaBuilderContext {
  final BuildContext buildContext;
  final String url;
  final String urlNormal;
  final ResourceService? resourceService;
  final String Function()? getContents;
  final Function(String contents)? setContents;
  final double width;
  final double minWidth;
  final double startingWidth;
  final double maxWidth;
  final bool resizable;

  MediaBuilderContext({
    required this.buildContext,
    required this.url,
    required this.urlNormal,
    this.resourceService,
    this.getContents,
    this.setContents,
    required this.width,
    required this.minWidth,
    required this.startingWidth,
    required this.maxWidth,
    this.resizable = false,
  });
}

typedef MediaBuilder =
    Widget Function(String url, Map<String, String> attributes);
typedef ErrorMediaBuilder =
    Widget Function(String url, String alt, Object error);
