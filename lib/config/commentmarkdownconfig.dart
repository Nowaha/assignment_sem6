import 'package:assignment_sem6/config/builder/mediabuilder.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:flutter/widgets.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/all.dart';

final commentMarkdownConfigs = [
  CommentHeader(tag: MarkdownTag.h1.name, fontSize: 20),
  CommentHeader(tag: MarkdownTag.h2.name, fontSize: 18),
  CommentHeader(tag: MarkdownTag.h3.name, fontSize: 16),
  CommentHeader(tag: MarkdownTag.h4.name, fontSize: 14),
  CommentHeader(tag: MarkdownTag.h5.name, fontSize: 14),
  CommentHeader(tag: MarkdownTag.h6.name, fontSize: 14),
  PConfig(textStyle: PConfig().textStyle.copyWith(fontSize: 14)),
];

MarkdownConfig commentMarkdownConfig({required BuildContext context}) =>
    MarkdownConfig(
      configs: [
        ImgConfig(builder: postMediaBuilder(context, maxWidth: 300)),
        ...commentMarkdownConfigs,
      ],
    );

MarkdownConfig commentEditMarkdownConfig({
  required BuildContext context,
  required ResourceService localResourceService,
  required String Function() getContents,
  required Function(String contents) setContents,
}) => MarkdownConfig(
  configs: [
    ImgConfig(
      builder: editPostMediaBuilder(
        context: context,
        localResourceService: localResourceService,
        getContents: getContents,
        setContents: setContents,
        maxWidth: 300,
      ),
    ),
    ...commentMarkdownConfigs,
  ],
);

class CommentHeader extends HeadingConfig {
  @override
  final TextStyle style;
  @override
  final String tag;
  @override
  final EdgeInsets padding;
  @override
  final HeadingDivider? divider;

  CommentHeader({
    required this.tag,
    required double fontSize,
    this.divider,
    this.padding = const EdgeInsets.only(top: 16, bottom: 0),
  }) : style = TextStyle(
         fontSize: fontSize,
         height: 1.2,
         fontWeight: FontWeight.bold,
       );
}
