import 'package:flutter/material.dart';

class Screen extends StatelessWidget {
  static const padding = EdgeInsets.all(16);

  final Widget title;
  final Widget child;
  final List<Widget>? appBarActions;
  final Widget? floatingActionButton;

  const Screen._({
    super.key,
    required this.title,
    required this.child,
    this.appBarActions,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: title, actions: appBarActions),
    body: child,
    floatingActionButton: floatingActionButton,
  );

  factory Screen({
    Key? key,
    required Widget title,
    required Widget child,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
  }) => Screen._(
    key: key,
    title: title,
    appBarActions: appBarActions,
    floatingActionButton: floatingActionButton,
    child: Padding(padding: padding, child: child),
  );

  factory Screen.center({
    Key? key,
    required Widget title,
    required Widget child,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
  }) => Screen._(
    key: key,
    title: title,
    appBarActions: appBarActions,
    floatingActionButton: floatingActionButton,
    child: Padding(padding: padding, child: Center(child: child)),
  );

  factory Screen.scroll({
    Key? key,
    required Widget title,
    required Widget child,
    List<Widget>? appBarActions,
    Widget? floatingActionButton,
    Alignment alignment = Alignment.topCenter,
  }) => Screen._(
    key: key,
    title: title,
    appBarActions: appBarActions,
    floatingActionButton: floatingActionButton,
    child: Align(
      alignment: alignment,
      child: SingleChildScrollView(padding: padding, child: child),
    ),
  );
}
