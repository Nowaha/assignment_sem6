import 'package:assignment_sem6/extension/color.dart';
import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  static const defaultPadding = EdgeInsets.all(16);

  final Widget title;
  final Widget child;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;
  final Color? backgroundColor;

  const Screen._({
    super.key,
    required this.title,
    required this.child,
    this.appBarActions,
    this.floatingActionButton,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: title,
      actions: appBarActions,
      actionsPadding: EdgeInsets.only(right: 8),
      backgroundColor: backgroundColor ?? Theme.of(context).colorScheme.primary,
      foregroundColor:
          backgroundColor?.getForegroundColor() ??
          Theme.of(context).colorScheme.onPrimary,
    ),
    body: child,
    floatingActionButton: floatingActionButton,
  );

  factory Screen({
    Key? key,
    required Widget title,
    required Widget child,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
    EdgeInsets padding = defaultPadding,
    Color? backgroundColor,
    Color? foregroundColor,
  }) => Screen._(
    key: key,
    title: title,
    appBarActions: appBarActions,
    floatingActionButton: floatingActionButton,
    backgroundColor: backgroundColor,
    child: Padding(padding: padding, child: child),
  );

  factory Screen.center({
    Key? key,
    required Widget title,
    required Widget child,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
    EdgeInsets padding = defaultPadding,
    Color? backgroundColor,
    Color? foregroundColor,
  }) => Screen._(
    key: key,
    title: title,
    appBarActions: appBarActions,
    floatingActionButton: floatingActionButton,
    backgroundColor: backgroundColor,
    child: Padding(padding: padding, child: Center(child: child)),
  );

  factory Screen.scroll({
    Key? key,
    required Widget title,
    required Widget child,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
    Alignment alignment = Alignment.topCenter,
    EdgeInsets padding = defaultPadding,
    Color? backgroundColor,
    Color? foregroundColor,
  }) => Screen._(
    key: key,
    title: title,
    appBarActions: appBarActions,
    floatingActionButton: floatingActionButton,
    backgroundColor: backgroundColor,
    child: Align(
      alignment: alignment,
      child: SingleChildScrollView(padding: padding, child: child),
    ),
  );
}
