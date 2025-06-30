import 'package:flutter/material.dart';

class ActualTextButton extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Color? hoverColor;
  final Function()? onTap;
  final Function(bool)? onHover;

  const ActualTextButton({
    super.key,
    required this.text,
    this.style,
    this.hoverColor,
    this.onTap,
    this.onHover,
  });

  @override
  State<StatefulWidget> createState() => _ActualTextButtonState();
}

class _ActualTextButtonState extends State<ActualTextButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovered) {
        setState(() {
          _hovered = hovered;
        });
        if (widget.onHover != null) {
          widget.onHover!(hovered);
        }
      },
      child: Text(
        widget.text,
        style:
            widget.style?.copyWith(
              color:
                  _hovered
                      ? widget.hoverColor ??
                          Theme.of(context).colorScheme.primary
                      : null,
              decoration: _hovered ? TextDecoration.underline : null,
            ) ??
            TextStyle(
              color:
                  _hovered
                      ? widget.hoverColor ??
                          Theme.of(context).colorScheme.primary
                      : null,
              decoration: _hovered ? TextDecoration.underline : null,
            ),
      ),
    );
  }
}
