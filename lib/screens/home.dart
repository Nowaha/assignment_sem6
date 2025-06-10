import 'package:assignment_sem6/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semester 6'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context.go('/${SettingsPage.routeName}');
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Text("Home"),
    );
  }
}
