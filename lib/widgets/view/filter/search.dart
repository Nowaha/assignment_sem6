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
        spacing: 10.0,
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Search",
              ),
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onEditingComplete:
                  () => widget.onSearch(
                    _searchController.text.trim().toLowerCase(),
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
          Text("Search in:"),
          Checkbox(value: true, onChanged: (value) {}),
          const Text("Title"),
          const SizedBox(width: 8.0),
          Checkbox(value: true, onChanged: (value) {}),
          const Text("Contents"),
          const SizedBox(width: 8.0),
          Checkbox(value: true, onChanged: (value) {}),
          const Text("Tags"),
        ],
      ),
    ],
  );
}
