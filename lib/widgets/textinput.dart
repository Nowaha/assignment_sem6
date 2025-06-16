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

  Widget _buildWidget() => TextField(
    controller: widget.controller,
    onChanged: widget.onChanged,
    enabled: widget.enabled,
    obscureText: _obscure,
    maxLines: widget.maxLines ?? 1,
    textInputAction: widget.textInputAction,
    onSubmitted: widget.onSubmitted,
    keyboardType:
        widget.keyboardType ??
        (widget.obscure == true
            ? TextInputType.visiblePassword
            : TextInputType.text),
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      errorText: widget.errorText,
      label: Text(widget.label),
      suffixIcon:
          widget.obscure != null
              ? ObscureToggle(obscure: _obscure, toggleObscure: _toggleObscure)
              : null,
    ),
  );

  @override
  Widget build(BuildContext context) =>
      (widget.expand == true)
          ? Expanded(child: _buildWidget())
          : _buildWidget();
}
