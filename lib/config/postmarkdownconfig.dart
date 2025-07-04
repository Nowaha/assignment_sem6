import 'package:assignment_sem6/config/builder/mediabuilder.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/inlines/img.dart';

MarkdownConfig postMarkdownConfig(BuildContext context) =>
    MarkdownConfig(configs: [ImgConfig(builder: postMediaBuilder(context))]);
