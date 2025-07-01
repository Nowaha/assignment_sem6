import 'package:assignment_sem6/widgets/collapsible/collapsiblecontainer.dart';
import 'package:flutter/material.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CollapsibleContainer(
      title: "Filters",
      initiallyCollapsed: true,
      child: Column(children: [Text("Filter options will go here")]),
    );
  }
}
