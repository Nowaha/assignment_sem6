import 'package:assignment_sem6/data/service/resourceservice.dart';
import 'package:assignment_sem6/extension/textformatting.dart';
import 'package:assignment_sem6/screens/post/markdownhelp.dart';
import 'package:assignment_sem6/util/fileutil.dart';
import 'package:assignment_sem6/widgets/input/text/editorcontrols.dart';
import 'package:assignment_sem6/widgets/input/text/textinput.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide TextInput;

class MarkdownEditor extends StatefulWidget {
  final TextEditingController controller;
  final ResourceService resourceService;
  final String label;
  final bool enabled;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final bool? showCounter;

  const MarkdownEditor({
    super.key,
    required this.resourceService,
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
  final FocusNode _focusNode = FocusNode();

  void _pickImage() async {
    if (!widget.enabled) return;

    final resource = await FileUtil.pickFileAsResource(FileType.image);
    if (resource != null) {
      await widget.resourceService.addResource(resource);
      widget.controller.insertImage(resource.name, resource.uuid);
      _focusNode.requestFocus();
    }
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
                  widget.controller.wrapSelection("*", "*");
                  return null;
                },
              ),
              BoldIntent: CallbackAction(
                onInvoke: (e) {
                  widget.controller.wrapSelection("**", "**");
                  return null;
                },
              ),
            },
            child: TextInput(
              focusNode: _focusNode,
              controller: widget.controller,
              label: widget.label,
              enabled: widget.enabled,
              errorText: widget.errorText,
              onChanged: widget.onChanged,
              minLines: 3,
              maxLines: null,
              maxLength: widget.maxLength,
              showCounter: widget.showCounter,
              padding: EdgeInsets.only(
                top: 16.0,
                right: 12.0,
                bottom: 54.0,
                left: 12.0,
              ),
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
                  isScrollControlled: true,
                  constraints: BoxConstraints(
                    maxWidth: 500,
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  builder: (context) => MarkdownHelp(),
                );
              },
              icon: Icon(Icons.help),
            ),
          ),
        ),
        Positioned(
          left: 4.0,
          bottom: 24.0,
          child: EditorControls(
            textFocusNode: _focusNode,
            textController: widget.controller,
            openImageSelector: _pickImage,
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
