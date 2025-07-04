import 'package:assignment_sem6/extension/textformatting.dart';
import 'package:flutter/material.dart';

class EditorControls extends StatefulWidget {
  final FocusNode textFocusNode;
  final TextEditingController textController;
  final VoidCallback? openImageSelector;
  final bool enabled;

  const EditorControls({
    super.key,
    required this.textFocusNode,
    required this.textController,
    this.openImageSelector,
    this.enabled = true,
  });

  @override
  State<EditorControls> createState() => _EditorControlsState();
}

class _EditorControlsState extends State<EditorControls> {
  bool _hovered = false;

  void _wrap(String char) {
    if (!widget.enabled) return;
    widget.textController.wrapSelection(char, char);
    widget.textFocusNode.requestFocus();
  }

  void _prefix(String prefix) {
    if (!widget.enabled) return;
    widget.textController.addStartOfLines(prefix);
    widget.textFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final bool anyMultiMedia = widget.openImageSelector != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: _hovered ? 1.0 : 0.5,
        child: Row(
          spacing: 4.0,
          children: [
            IconButton(
              icon: Icon(Icons.format_bold),
              tooltip: "Bold (Ctrl/Cmd + B)",
              onPressed: () => _wrap("**"),
            ),
            IconButton(
              icon: Icon(Icons.format_italic),
              tooltip: "Italicize (Ctrl/Cmd + I)",
              onPressed: () => _wrap("*"),
            ),
            IconButton(
              icon: Icon(Icons.format_quote),
              tooltip: "Blockquote",
              onPressed: () => _prefix("> "),
            ),
            IconButton(
              icon: Icon(Icons.format_list_bulleted),
              tooltip: "Bullet List",
              onPressed: () => _prefix("- "),
            ),
            IconButton(
              icon: Icon(Icons.format_list_numbered),
              tooltip: "Numbered List",
              onPressed: () => _prefix("1. "),
            ),
            if (anyMultiMedia)
              Container(
                color: Theme.of(context).colorScheme.onSurface.withAlpha(100),
                width: 2.0,
                height: 16.0,
              ),
            if (widget.openImageSelector != null)
              IconButton(
                icon: Icon(Icons.add_photo_alternate),
                tooltip: "Add image",
                onPressed: widget.openImageSelector!,
              ),
          ],
        ),
      ),
    );
  }
}
