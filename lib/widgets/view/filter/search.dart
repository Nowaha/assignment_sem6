import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;

  const SearchWidget({super.key, required this.onSearch});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => Column(
    spacing: 8.0,
    children: [
      Row(
        spacing: 8.0,
        children: [
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Search",
                ),
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onSubmitted:
                    (value) => widget.onSearch(value.trim().toLowerCase()),
              ),
            ),
          ),
          IconButton.filledTonal(
            onPressed: () {
              widget.onSearch(_searchController.text.trim().toLowerCase());
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      Row(
        children: [
          Checkbox(value: true, onChanged: (value) {}),
          const Text("Include Title"),
          const SizedBox(width: 8.0),
          Checkbox(value: true, onChanged: (value) {}),
          const Text("Include Contents"),
          const SizedBox(width: 8.0),
          Checkbox(value: true, onChanged: (value) {}),
          const Text("Include Tags"),
        ],
      ),
    ],
  );
}
