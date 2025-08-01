import 'package:assignment_sem6/widgets/input/text/obscuretoggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatefulWidget {
  final FocusNode? focusNode;
  final String label;
  final String? errorText;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final bool? obscure;
  final bool? enabled;
  final bool? expand;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool? showCounter;
  final ValueChanged<String>? onSubmitted;
  final bool autoFocus;
  final EdgeInsets? padding;

  const TextInput({
    super.key,
    this.focusNode,
    required this.label,
    this.errorText,
    required this.controller,
    this.onChanged,
    this.obscure,
    this.enabled,
    this.expand,
    this.textInputAction,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.maxLength,
    this.showCounter = false,
    this.onSubmitted,
    this.autoFocus = false,
    this.padding,
  });

  @override
  State<StatefulWidget> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  bool _obscure = false;

  @override
  void initState() {
    super.initState();
    _obscure = widget.obscure ?? false;
  }

  void _toggleObscure() {
    setState(() {
      _obscure = !_obscure;
    });
  }

  Widget _buildWidget() {
    final bool isMultiline = (widget.minLines ?? 1) > 1;

    final TextInputAction? textInputAction;
    final TextInputType? textInputType;

    if (isMultiline) {
      textInputAction = TextInputAction.newline;
      textInputType = TextInputType.multiline;
    } else {
      textInputAction = widget.textInputAction;
      textInputType =
          widget.keyboardType ??
          (widget.obscure == true
              ? TextInputType.visiblePassword
              : TextInputType.text);
    }

    final textField = TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      obscureText: _obscure,
      textAlignVertical: TextAlignVertical.top,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      maxLengthEnforcement:
          widget.maxLength != null ? MaxLengthEnforcement.enforced : null,
      textInputAction: textInputAction,
      onSubmitted: widget.onSubmitted,
      keyboardType: textInputType,
      autofocus: widget.autoFocus,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        errorText: widget.errorText,
        label: Text(widget.label),
        contentPadding: widget.padding,
        floatingLabelAlignment: FloatingLabelAlignment.start,
        alignLabelWithHint: true,
        counterText: "",
        suffixIcon:
            widget.obscure != null
                ? ObscureToggle(
                  obscure: _obscure,
                  toggleObscure: _toggleObscure,
                )
                : null,
      ),
    );

    if (widget.showCounter == true && widget.maxLength != null) {
      return Stack(
        children: [
          textField,
          ListenableBuilder(
            listenable: widget.controller,
            builder: (context, child) {
              final length = widget.controller.text.length;
              return Positioned(
                right: 12,
                bottom: widget.errorText == null ? 12 : 32,
                child: IgnorePointer(
                  child: Text(
                    "$length/${widget.maxLength}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
    }

    return textField;
  }

  @override
  Widget build(BuildContext context) =>
      (widget.expand == true)
          ? Expanded(child: _buildWidget())
          : _buildWidget();
}
