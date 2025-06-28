import 'package:flutter/material.dart';

class Toast {
  static void showToast(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: duration, showCloseIcon: true),
    );
  }

  void clearToasts(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

class ToastLength {
  static const Duration short = Duration(seconds: 2);
  static const Duration long = Duration(seconds: 4);
}
