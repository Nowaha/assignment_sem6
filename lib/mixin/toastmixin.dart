import 'package:flutter/material.dart';

mixin ToastMixin<T extends StatefulWidget> on State<T> {
  void showToast(
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: duration, showCloseIcon: true),
    );
  }

  void clearToasts() {
    ScaffoldMessenger.of(context).clearSnackBars();
  }
}

class ToastLength {
  static const Duration short = Duration(seconds: 2);
  static const Duration long = Duration(seconds: 4);
}
