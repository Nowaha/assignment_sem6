import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

mixin ToastMixin<T extends StatefulWidget> on State<T> {
  late final FToast fToast;

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);
  }

  void showToast(
    String message, {
    bool replace = true,
    Toast toastLength = Toast.LENGTH_SHORT,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    Duration toastDuration =
        toastLength == Toast.LENGTH_SHORT
            ? Duration(seconds: 2)
            : Duration(seconds: 5);

    if (replace) {
      clearToasts();
    }

    fToast.showToast(
      child: Card(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ),
      gravity: gravity,
      toastDuration: toastDuration,
    );
  }

  void clearToasts() {
    fToast.removeCustomToast();
  }
}
