import 'package:flutter/widgets.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/all.dart';

final commentMarkdownConfig = MarkdownConfig(
  configs: [
    CommentHeader(tag: MarkdownTag.h1.name, fontSize: 20),
    CommentHeader(tag: MarkdownTag.h2.name, fontSize: 18),
    CommentHeader(tag: MarkdownTag.h3.name, fontSize: 16),
    CommentHeader(tag: MarkdownTag.h4.name, fontSize: 14),
    CommentHeader(tag: MarkdownTag.h5.name, fontSize: 14),
    CommentHeader(tag: MarkdownTag.h6.name, fontSize: 14),
    PConfig(textStyle: PConfig().textStyle.copyWith(fontSize: 14)),
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
