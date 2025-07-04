import 'package:assignment_sem6/extension/iterable.dart';
import 'package:assignment_sem6/util/keyboard.dart';
import 'package:assignment_sem6/widgets/shakeable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChipListInput extends StatefulWidget {
  final String hintText;
  final List<String> chips;
  final ValueChanged<String> onChipAdded;
  final ValueChanged<String> onChipRemoved;
  final int maxTextLength;
  final int maxLength;
  final List<String> suggestions;
  final bool suggestOnFocus;
  final bool strict;

  const ChipListInput({
    super.key,
    this.hintText = "+ Add",
    required this.chips,
    required this.onChipAdded,
    required this.onChipRemoved,
    this.maxTextLength = 16,
    this.maxLength = 50,
    this.suggestions = const [],
    this.suggestOnFocus = false,
    this.strict = false,
  });

  @override
  State<ChipListInput> createState() => _ChipListInputState();
}

class _ChipListInputState extends State<ChipListInput> {
  final shakeKey = GlobalKey<ShakeableState>();
  final TextEditingController _controller = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();
  List<String> filteredSuggestions = [];

  @override
  void initState() {
    _controller.addListener(_updateFiltered);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }

  void _addChip() {
    String chip = _controller.text.trim();

    if (widget.chips.length >= widget.maxLength) {
      shakeKey.currentState?.shake();
      return;
    }
    if (chip.isEmpty || widget.chips.contains(chip)) {
      shakeKey.currentState?.shake();
      return;
    }

    if (widget.strict) {
      final lower = chip.toLowerCase();
      final found = widget.suggestions.firstWhereOrNull(
        (s) => s.toLowerCase() == lower,
      );
      if (found == null) {
        shakeKey.currentState?.shake();
        return;
      }
      chip = found;
    }

    widget.onChipAdded(chip);
    _controller.clear();
    _updateFiltered();
  }

  KeyEventResult _onKeyEvent(FocusNode focusNode, KeyEvent event) {
    if (event is KeyDownEvent || event is KeyRepeatEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controller.text.isEmpty && widget.chips.isEmpty) {
          shakeKey.currentState?.shake();
          return KeyEventResult.handled;
        }

        if (_controller.text.isNotEmpty || widget.chips.isEmpty) {
          return KeyEventResult.ignored;
        }

        _goToPreviousChip();
        return KeyEventResult.handled;
      } else if (event.logicalKey == LogicalKeyboardKey.tab) {
        final isShiftPressed = KeyboardUtil.isShiftPressed();

        if (isShiftPressed) {
          if (widget.chips.isEmpty) {
            shakeKey.currentState?.shake();
            return KeyEventResult.handled;
          }

          _goToPreviousChip();
          return KeyEventResult.handled;
        }

        _updateFiltered();
        if (filteredSuggestions.isNotEmpty) {
          _controller.text = filteredSuggestions.first;
          _addChip();
          return KeyEventResult.handled;
        } else if (widget.suggestions.contains(_controller.text) ||
            widget.suggestions.isEmpty) {
          _addChip();
        } else {
          shakeKey.currentState?.shake();
        }
        return KeyEventResult.handled;
      }
    }
    return KeyEventResult.ignored;
  }

  void _goToPreviousChip() {
    final lastChip = widget.chips.last;
    widget.onChipRemoved(lastChip);
    _controller.text = lastChip;
    _controller.selection = TextSelection.fromPosition(
      TextPosition(offset: _controller.text.length),
    );
    _updateFiltered();
  }

  void _updateFiltered() {
    final input = _controller.text.toLowerCase();
    if (input.isEmpty && !widget.suggestOnFocus) {
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
              _updateFiltered();
            },
          ),
        ),
      ),
      if (widget.chips.length < widget.maxLength)
        Shakeable(
          key: shakeKey,
          child: InputChip(
            backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
            onPressed: _inputFocusNode.requestFocus,
            label: IntrinsicWidth(
              child: Focus(
                focusNode: FocusNode(),
                onKeyEvent: _onKeyEvent,
                child: TextField(
                  focusNode: _inputFocusNode,
                  style: TextStyle(fontSize: 14),
                  decoration: InputDecoration.collapsed(
                    hintText: widget.hintText,
                  ).copyWith(counterText: ""),
                  controller: _controller,
                  onEditingComplete: _addChip,
                  maxLength: widget.maxTextLength,
                ),
              ),
            ),
          ),
        ),
      if (widget.chips.length < widget.maxLength)
        ...widget.suggestions
            .where(
              (s) => s.toLowerCase().contains(_controller.text.toLowerCase()),
            )
            .where((s) => !widget.chips.contains(s))
            .map(
              (suggestion) => ActionChip(
                backgroundColor: Colors.transparent,
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                ),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4,
                  children: [Text(suggestion), Icon(Icons.add, size: 12)],
                ),
                onPressed: () {
                  _controller.text = suggestion;
                  _addChip();
                },
                shape: StadiumBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withAlpha(150),
                    width: 0.5, // Border width
                  ),
                ),
              ),
            ),
    ],
  );
}
