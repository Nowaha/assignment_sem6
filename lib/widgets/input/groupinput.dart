import 'package:assignment_sem6/data/service/groupservice.dart';
import 'package:assignment_sem6/util/validation.dart';
import 'package:assignment_sem6/widgets/input/chiplistinput.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupInput extends StatefulWidget {
  final Map<String, String> selectedGroups;
  final Function(Map<String, String>) onChanged;
  final int maxTextLength;
  final int maxLength;

  const GroupInput({
    super.key,
    required this.selectedGroups,
    required this.onChanged,
    this.maxLength = Validation.maxPostGroups,
    this.maxTextLength = 100,
  });

  @override
  State<GroupInput> createState() => _GroupInputState();
}

class _GroupInputState extends State<GroupInput> {
  final Map<String, String> _allGroups = {};

  @override
  void initState() {
    super.initState();

    _fetchGroups();
  }

  void _fetchGroups() async {
    final groupService = context.read<GroupService>();
    final groups = await groupService.getAll();

    if (!context.mounted) return;

    setState(() {
      _allGroups.clear();
      _allGroups.addAll({for (final group in groups) group.name: group.uuid});
      _allGroups.remove("Everyone");
    });
  }

  @override
  Widget build(BuildContext context) => ChipListInput(
    chips: widget.selectedGroups.keys.toList(),
    hintText: "+ Add group",
    maxLength: widget.maxLength,
    maxTextLength: widget.maxTextLength,
    suggestions: _allGroups.keys.toList(),
    onChipAdded:
        (String chip) => widget.onChanged({
          ...widget.selectedGroups,
          chip: _allGroups[chip]!,
        }),
    onChipRemoved:
        (String chip) => widget.onChanged(widget.selectedGroups..remove(chip)),
    suggestOnFocus: true,
    strict: true,
  );
}
