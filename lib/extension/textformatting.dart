import 'package:flutter/material.dart';

extension TextFormattingExtension on TextEditingController {
  void addStartOfLines(String prefix) {
    if (!selection.isValid || selection.isCollapsed) return;

    final lines = selection.textInside(text).split("\n");
    final hasPrefix = lines.any((line) => line.startsWith(prefix));
    final newText = lines
        .map(
          (line) => hasPrefix ? line.replaceFirst(prefix, "") : prefix + line,
        )
        .join("\n");

    value = TextEditingValue(
      text: selection.textBefore(text) + newText + selection.textAfter(text),
      selection: TextSelection(
        baseOffset: selection.start,
        extentOffset:
            selection.end +
            (newText.length - selection.textInside(text).length),
      ),
    );
  }

  void wrapSelection(String left, String right) {
    if (!selection.isValid || selection.isCollapsed) return;

    final existing = selection.textInside(text);
    if (existing.startsWith(left) && existing.endsWith(right)) {
      final newText =
          selection.textBefore(text) +
          existing.substring(left.length, existing.length - right.length) +
          selection.textAfter(text);

      final newSelection = TextSelection(
        baseOffset: selection.start,
        extentOffset: selection.end - left.length - right.length,
      );

      value = TextEditingValue(text: newText, selection: newSelection);
      return;
    } else {
      final newText =
          selection.textBefore(text) +
          left +
          existing +
          right +
          selection.textAfter(text);

      final newSelection = TextSelection(
        baseOffset: selection.start,
        extentOffset: selection.end + left.length + right.length,
      );

      value = TextEditingValue(text: newText, selection: newSelection);
    }
  }

  void insertImage(
    String fileName,
    String fileUUID, {
    int startingWidth = 300,
  }) {
    final imageMarkdown = "![$fileName](image:$fileUUID|width=$startingWidth)";
    final newText =
        selection.textBefore(text) + imageMarkdown + selection.textAfter(text);

    final newSelection = TextSelection(
      baseOffset: selection.start,
      extentOffset: selection.end + imageMarkdown.length,
    );

    value = TextEditingValue(text: newText, selection: newSelection);
  }

  void insertVideo(
    String fileName,
    String fileUUID, {
    int startingWidth = 300,
  }) {
    final videoMarkdown = "![$fileName](video:$fileUUID|width=$startingWidth)";
    final newText =
        selection.textBefore(text) + videoMarkdown + selection.textAfter(text);

    final newSelection = TextSelection(
      baseOffset: selection.start,
      extentOffset: selection.end + videoMarkdown.length,
    );

    value = TextEditingValue(text: newText, selection: newSelection);
  }
}
