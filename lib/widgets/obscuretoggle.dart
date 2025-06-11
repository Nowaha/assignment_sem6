import 'package:flutter/material.dart';

class ObscureToggle extends StatelessWidget {
  final bool obscure;
  final VoidCallback? toggleObscure;

  const ObscureToggle({
    super.key,
    required this.obscure,
    required this.toggleObscure,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8.0),
    child: IconButton(
      icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
      onPressed: toggleObscure,
    ),
  );
}
