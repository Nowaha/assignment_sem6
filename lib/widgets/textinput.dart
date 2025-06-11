import 'package:assignment_sem6/widgets/obscuretoggle.dart';
import 'package:flutter/material.dart';

class TextInput extends StatefulWidget {
  final String label;
  final String? errorText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool? obscure;
  final bool? enabled;

  const TextInput({
    super.key,
    required this.label,
    this.errorText,
    this.controller,
    this.onChanged,
    this.obscure,
    this.enabled,
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

  @override
  Widget build(BuildContext context) => TextField(
    controller: widget.controller,
    onChanged: widget.onChanged,
    enabled: widget.enabled,
    obscureText: _obscure,
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
}
