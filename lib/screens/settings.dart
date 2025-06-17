import 'package:assignment_sem6/providers/themeprovider.dart';
import 'package:assignment_sem6/widgets/screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const String routeName = "settings";

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Screen.scroll(
      title: const Text('Settings'),
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text("Appearance", style: Theme.of(context).textTheme.titleLarge),
          Row(
            spacing: 8,
            children: [
              Text(
                "Use system theme",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Switch(
                value: themeProvider.system,
                onChanged: (newVal) {
                  themeProvider.toggleSystem();
                },
              ),
            ],
          ),
          Row(
            spacing: 8,
            children: [
              Text(
                "Dark Mode",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color:
                      themeProvider.system
                          ? Theme.of(context).disabledColor
                          : null,
                ),
              ),
              Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged:
                    themeProvider.system
                        ? null
                        : (newVal) {
                          themeProvider.toggleTheme();
                        },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
