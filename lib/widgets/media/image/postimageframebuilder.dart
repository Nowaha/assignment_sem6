import 'package:assignment_sem6/widgets/sizedcircularprogressindicator.dart';
import 'package:flutter/material.dart';

ImageFrameBuilder postImageFrameBuilder = (
  context,
  child,
  frame,
  wasSynchronouslyLoaded,
) {
  if (wasSynchronouslyLoaded) return child;
  if (frame == null) {
    return loadingWidget;
  }
  return child;
};

Widget loadingWidget = Container(
  height: 100,
  decoration: BoxDecoration(
    color: Colors.grey[700],
    borderRadius: BorderRadius.circular(8),
  ),
  child: Center(child: SizedCircularProgressIndicator.square(size: 32)),
);
