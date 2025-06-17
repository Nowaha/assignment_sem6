import 'package:assignment_sem6/widgets/form/labeled.dart';
import 'package:flutter/material.dart';

class Group extends StatelessWidget {
  final String? label;
  final List<Widget> children;
  final GroupOrientation orientation;

  const Group({
    super.key,
    this.label,
    required this.children,
    this.orientation = GroupOrientation.vertical,
  });

  Group.single(this.label, Widget child, {super.key})
    : children = [child],
      orientation = GroupOrientation.vertical;

  const Group.horizontal({super.key, this.label, required this.children})
    : orientation = GroupOrientation.horizontal;

  const Group.vertical({super.key, this.label, required this.children})
    : orientation = GroupOrientation.vertical;

  @override
  Widget build(BuildContext context) {
    final contents = switch (orientation) {
      GroupOrientation.vertical => Column(spacing: 8, children: children),
      GroupOrientation.horizontal => Row(
        spacing: 8,
        children: children.map((it) => Expanded(child: it)).toList(),
      ),
    };

    if (label != null) {
      return Labeled(label!, child: contents);
    }
    return contents;
  }
}

enum GroupOrientation { vertical, horizontal }
