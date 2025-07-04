import 'package:assignment_sem6/extension/color.dart';
import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  static const defaultPadding = EdgeInsets.all(16);

  final Widget title;
  final Widget child;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Color? backgroundColor;
  final Widget? leading;

  const Screen._({
    super.key,
    required this.title,
    required this.child,
    this.leading,
    this.appBarActions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: title,
      actions: appBarActions,
      leading: leading,
      actionsPadding: EdgeInsets.only(right: 8),
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      foregroundColor:
          backgroundColor?.getForegroundColor() ??
          Theme.of(context).colorScheme.onPrimary,
    ),
    body: child,
    floatingActionButton: floatingActionButton,
    floatingActionButtonLocation: floatingActionButtonLocation,
  );

  factory Screen({
    Key? key,
    required Widget title,
    required Widget child,
    Widget? leading,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    EdgeInsets padding = defaultPadding,
    Color? backgroundColor,
    Color? foregroundColor,
  }) => Screen._(
    key: key,
    title: title,
    leading: leading,
    appBarActions: appBarActions,
    floatingActionButton: floatingActionButton,
    floatingActionButtonLocation: floatingActionButtonLocation,
    backgroundColor: backgroundColor,
    child: Padding(padding: padding, child: child),
  );

  factory Screen.center({
    Key? key,
    required Widget title,
    required Widget child,
    Widget? leading,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    EdgeInsets padding = defaultPadding,
    Color? backgroundColor,
    Color? foregroundColor,
  }) => Screen._(
    key: key,
    title: title,
    leading: leading,
    appBarActions: appBarActions,
    floatingActionButton: floatingActionButton,
    floatingActionButtonLocation: floatingActionButtonLocation,
    backgroundColor: backgroundColor,
    child: Padding(padding: padding, child: Center(child: child)),
  );

  factory Screen.scroll({
    Key? key,
    required Widget title,
    required Widget child,
    Widget? leading,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
    FloatingActionButtonLocation? floatingActionButtonLocation,
    EdgeInsets defaultPadding = const EdgeInsets.all(16),
    Alignment alignment = Alignment.topCenter,
    EdgeInsets padding = defaultPadding,
    Color? backgroundColor,
    Color? foregroundColor,
  }) => Screen._(
    key: key,
    title: title,
    leading: leading,
    appBarActions: appBarActions,
    floatingActionButton: floatingActionButton,
    floatingActionButtonLocation: floatingActionButtonLocation,
    backgroundColor: backgroundColor,
    child: Align(
      alignment: alignment,
      child: SingleChildScrollView(padding: padding, child: child),
    ),
  );
}
