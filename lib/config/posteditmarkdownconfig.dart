import 'package:assignment_sem6/widgets/media/builder/mediabuilder.dart';
import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:flutter/material.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/inlines/img.dart';

MarkdownConfig postEditMarkdownConfig({
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
      ),
    ),
  ],
);
