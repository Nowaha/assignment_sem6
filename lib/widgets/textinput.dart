import 'package:assignment_sem6/widgets/obscuretoggle.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String label;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool? obscure;
  final bool? enabled;
  final bool? expand;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  final ValueChanged<String>? onSubmitted;

  const TextInput({
    super.key,
    required this.label,
    this.errorText,
    this.controller,
    this.onChanged,
    this.obscure,
    this.enabled,
    this.expand,
    this.textInputAction,
    this.keyboardType,
    this.minLines,
    this.maxLines,
    this.onSubmitted,
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

    return TextField(
      controller: widget.controller,
      onChanged: widget.onChanged,
      enabled: widget.enabled,
      obscureText: _obscure,
      textAlignVertical: TextAlignVertical.top,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      textInputAction: textInputAction,
      onSubmitted: widget.onSubmitted,
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        errorText: widget.errorText,
        label: Text(widget.label),
        floatingLabelAlignment: FloatingLabelAlignment.start,
        alignLabelWithHint: true,
        suffixIcon:
            widget.obscure != null
                ? ObscureToggle(
                  obscure: _obscure,
                  toggleObscure: _toggleObscure,
                )
                : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) =>
      (widget.expand == true)
          ? Expanded(child: _buildWidget())
          : _buildWidget();
}
