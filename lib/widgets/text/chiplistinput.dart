import 'package:assignment_sem6/widgets/shakeable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChipListInput extends StatefulWidget {
  final String hintText;
  final List<String> chips;
  final ValueChanged<String> onChipAdded;
  final ValueChanged<String> onChipRemoved;
  final List<String> suggestions;

  const ChipListInput({
    super.key,
    this.hintText = "+ Add",
    required this.chips,
    required this.onChipAdded,
    required this.onChipRemoved,
    this.suggestions = const [],
  });

  @override
  State<ChipListInput> createState() => _ChipListInputState();
}

class _ChipListInputState extends State<ChipListInput> {
  final shakeKey = GlobalKey<ShakeableState>();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> filteredSuggestions = [];

  @override
  void initState() {
    _controller.addListener(_onTextChanged);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addChip() {
    final chip = _controller.text.trim();
    if (chip.isEmpty || widget.chips.contains(chip)) {
      shakeKey.currentState?.shake();
      return;
    }

    widget.onChipAdded(chip);
    _controller.clear();
  }

  void _onKeyEvent(KeyEvent event) {
    if ((event is KeyDownEvent || event is KeyRepeatEvent) &&
        event.logicalKey == LogicalKeyboardKey.backspace) {
      if (_controller.text.isEmpty && widget.chips.isNotEmpty) {
        final lastChip = widget.chips.last;
        widget.onChipRemoved(lastChip);
        _controller.text = "$lastChip ";
        _controller.selection = TextSelection.fromPosition(
          TextPosition(offset: _controller.text.length),
        );
      }
    }
  }

  void _onTextChanged() {
    final input = _controller.text.toLowerCase();
    if (input.isEmpty) {
      setState(() {
        filteredSuggestions = [];
      });
      return;
    }

    setState(() {
      filteredSuggestions =
          widget.suggestions
              .where((s) => s.toLowerCase().contains(input))
              .where((s) => !widget.chips.contains(s))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 8,
    runSpacing: 8,
    children: [
      ...widget.chips.map(
        (chip) => Tooltip(
          message: chip,
          child: Chip(
            label: Text(chip),
            deleteIcon: Icon(Icons.close),
            onDeleted: () {
              widget.onChipRemoved(chip);
            },
          ),
        ),
      ),
      Shakeable(
        key: shakeKey,
        child: InputChip(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          onPressed: _focusNode.requestFocus,
          label: IntrinsicWidth(
            child: KeyboardListener(
              focusNode: FocusNode(),
              onKeyEvent: _onKeyEvent,
              child: TextField(
                focusNode: _focusNode,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration.collapsed(
                  hintText: widget.hintText,
                ).copyWith(counterText: ""),
                controller: _controller,
                onEditingComplete: _addChip,
                maxLength: 16,
              ),
            ),
          ),
        ),
      ),
      ...filteredSuggestions.map(
        (suggestion) => ActionChip(
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          label: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 4,
            children: [Text(suggestion), Icon(Icons.add, size: 12)],
          ),
          onPressed: () {
            _controller.text = suggestion;
            _addChip();
          },
        ),
      ),
    ],
  );
}
