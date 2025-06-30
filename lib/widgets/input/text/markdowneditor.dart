import 'package:assignment_sem6/screens/post/markdownhelp.dart';
import 'package:assignment_sem6/widgets/input/text/textinput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide TextInput;

class MarkdownEditor extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final bool? showCounter;

  const MarkdownEditor({
    super.key,
    required this.controller,
    required this.label,
    this.enabled = true,
    this.errorText,
    this.onChanged,
    this.maxLength,
    this.showCounter = true,
  });

  @override
  State<MarkdownEditor> createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  void _wrapSelection(String left, String right) {
    final text = widget.controller.text;
    final selection = widget.controller.selection;

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

      widget.controller.value = TextEditingValue(
        text: newText,
        selection: newSelection,
      );
      return;
    }

    final selectedText = selection.textInside(text);
    final newText =
        selection.textBefore(text) +
        left +
        selectedText +
        right +
        selection.textAfter(text);

    final newSelection = TextSelection(
      baseOffset: selection.start,
      extentOffset: selection.end + left.length + right.length,
    );

    widget.controller.value = TextEditingValue(
      text: newText,
      selection: newSelection,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Shortcuts(
          shortcuts: {
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyI):
                const ItalicizeIntent(),
            LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyI):
                const ItalicizeIntent(),
            LogicalKeySet(LogicalKeyboardKey.control, LogicalKeyboardKey.keyB):
                const BoldIntent(),
            LogicalKeySet(LogicalKeyboardKey.meta, LogicalKeyboardKey.keyB):
                const BoldIntent(),
          },
          child: Actions(
            actions: {
              ItalicizeIntent: CallbackAction(
                onInvoke: (e) {
                  _wrapSelection("*", "*");
                  return null;
                },
              ),
              BoldIntent: CallbackAction(
                onInvoke: (e) {
                  _wrapSelection("**", "**");
                  return null;
                },
              ),
            },
            child: TextInput(
              controller: widget.controller,
              label: widget.label,
              enabled: widget.enabled,
              errorText: widget.errorText,
              onChanged: widget.onChanged,
              minLines: 3,
              maxLines: null,
              maxLength: widget.maxLength,
              showCounter: widget.showCounter,
            ),
          ),
        ),
        Positioned(
          top: 8.0,
          right: 8.0,
          child: Tooltip(
            message: "Formatting Help",
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => MarkdownHelp(),
                );
              },
              icon: Icon(Icons.help),
            ),
          ),
        ),
      ],
    );
  }
}

class ItalicizeIntent extends Intent {
  const ItalicizeIntent();
}

class BoldIntent extends Intent {
  const BoldIntent();
}
