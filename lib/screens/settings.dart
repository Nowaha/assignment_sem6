import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = "settings";

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Screen.scroll(
      title: const Text('Settings'),
      child: Text("Settings"),
    );
  }
}
