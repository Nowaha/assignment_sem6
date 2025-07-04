import 'package:assignment_sem6/widgets/sizedcircularprogressindicator.dart';
import 'package:flutter/material.dart';

class LoadingIconButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onPressed;
  final bool disabledLookOnLoad;
  final ButtonType buttonType;
  final IconData icon;
  final double iconSize;
  final double textSize;
  final EdgeInsetsGeometry? padding;

  const LoadingIconButton({
    super.key,
    required this.label,
    required this.loading,
    this.onPressed,
    this.disabledLookOnLoad = false,
    this.buttonType = ButtonType.filled,
    required this.icon,
    this.iconSize = 14,
    this.textSize = 14,
    this.padding,
  });

  VoidCallback? getOnPressed() {
    if (onPressed == null) return null;
    if (loading) return disabledLookOnLoad ? null : () {};
    return onPressed;
  }

  @override
  Widget build(BuildContext context) {
    final buttonIcon =
        !loading
            ? Icon(icon, size: iconSize)
            : SizedCircularProgressIndicator.square(
              size: iconSize,
              strokeWidth: 2,
              onPrimary: buttonType == ButtonType.filled,
            );

    final textStyle = TextStyle(fontSize: textSize);

    switch (buttonType) {
      case ButtonType.filled:
        return FilledButton.icon(
          onPressed: getOnPressed(),
          label: Text(label, style: textStyle),
          icon: buttonIcon,
        );
      case ButtonType.outlined:
        return OutlinedButton.icon(
          onPressed: getOnPressed(),
          icon: buttonIcon,
          label: Text(label, style: textStyle),
        );
      case ButtonType.text:
        return TextButton.icon(
          onPressed: getOnPressed(),
          icon: buttonIcon,
          label: Text(label, style: textStyle),
        );
      case ButtonType.elevated:
        return ElevatedButton.icon(
          onPressed: getOnPressed(),
          icon: buttonIcon,
          label: Text(label, style: textStyle),
        );
      case ButtonType.fab:
        return FloatingActionButton(
          onPressed: getOnPressed(),
          tooltip: label,
          child: buttonIcon,
        );
    }
  }
}

enum ButtonType { filled, outlined, text, elevated, fab }
