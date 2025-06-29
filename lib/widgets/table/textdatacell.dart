import 'package:flutter/material.dart';

class TextDataCell extends DataCell {
  final String text;

  TextDataCell(this.text)
    : super(
        Tooltip(
          message: text,
          child: Text(text, maxLines: 1, overflow: TextOverflow.ellipsis),
        ),
      );
}
