import 'package:assignment_sem6/allinputscrollbehavior.dart';
import 'package:flutter/widgets.dart';

class DragScrollable extends StatelessWidget {
  final Axis scrollDirection;
  final Widget child;
  final ScrollController? controller;

  const DragScrollable({
    super.key,
    required this.scrollDirection,
    required this.child,
    this.controller,
  });

  @override
  Widget build(BuildContext context) => ScrollConfiguration(
    behavior: AllInputScrollBehavior(),
    child: SingleChildScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(),
      scrollDirection: scrollDirection,
      child: child,
    ),
  );
}
