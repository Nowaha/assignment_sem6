import 'package:assignment_sem6/widgets/form/label.dart';
import 'package:flutter/material.dart';

class Labeled extends StatelessWidget {
  final String label;
  final Widget child;

  const Labeled(this.label, {super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [Label(label), child],
    );
  }
}
