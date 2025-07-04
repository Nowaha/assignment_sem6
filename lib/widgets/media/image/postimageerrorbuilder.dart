import 'package:assignment_sem6/widgets/media/mediaerror.dart';
import 'package:flutter/material.dart';

ImageErrorWidgetBuilder postImageErrorBuilder =
    (context, error, stackTrace) =>
        MediaError(message: "Failed to load image.");
