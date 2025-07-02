import 'package:flutter/material.dart';

ImageErrorWidgetBuilder postImageErrorBuilder = (context, error, stackTrace) {
  return Container(
    color: Colors.grey[700],
    height: 100,
    child: Column(
      spacing: 8,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: Colors.red),
        Text(
          "Error loading image",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    ),
  );
};
