import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  bool _system = true;

  ThemeMode get themeMode => _system ? ThemeMode.system : _themeMode;
  bool get system => _system;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  void toggleSystem() {
    _system = !_system;
    notifyListeners();
  }
}
