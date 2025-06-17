import 'package:assignment_sem6/widgets/sizedcircularprogressindicator.dart';
import 'package:flutter/material.dart';

class LoadingIconButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback? onPressed;
  final Widget icon;
  final bool disabledLookOnLoad;
  final ButtonType buttonType;

  const LoadingIconButton({
    super.key,
    required this.label,
    required this.loading,
    this.onPressed,
    required this.icon,
    this.disabledLookOnLoad = false,
    this.buttonType = ButtonType.filled,
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
            ? icon
            : SizedCircularProgressIndicator.square(
              size: 14,
              strokeWidth: 2,
              onPrimary: buttonType == ButtonType.filled,
            );

    switch (buttonType) {
      case ButtonType.filled:
        return FilledButton.icon(
          onPressed: getOnPressed(),
          label: Text(label),
          icon: buttonIcon,
        );
      case ButtonType.outlined:
        return OutlinedButton.icon(
          onPressed: getOnPressed(),
          label: Text(label),
          icon: buttonIcon,
        );
      case ButtonType.text:
        return TextButton.icon(
          onPressed: getOnPressed(),
          label: Text(label),
          icon: buttonIcon,
        );
      case ButtonType.elevated:
        return ElevatedButton.icon(
          onPressed: getOnPressed(),
          label: Text(label),
          icon: buttonIcon,
        );
    }
  }
}

enum ButtonType { filled, outlined, text, elevated }
