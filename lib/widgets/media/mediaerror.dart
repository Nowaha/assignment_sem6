import 'package:flutter/material.dart';

class MediaError extends StatelessWidget {
  final String message;

  const MediaError({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.grey[700],
    height: 100,
    padding: const EdgeInsets.all(16),
    child: Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: Colors.red),
        Text(
          message,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    ),
  );
}
