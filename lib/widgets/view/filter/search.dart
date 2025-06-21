import 'package:assignment_sem6/widgets/textinput.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) => TextInput(
    label: "Search",
    controller: _searchController,
    textInputAction: TextInputAction.search,
  );
}
