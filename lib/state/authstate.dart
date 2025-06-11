import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:flutter/material.dart';

class AuthState extends ChangeNotifier {
  User? _loggedInUser;

  bool get isLoggedIn => _loggedInUser != null;

  User? get getCurrentUser => _loggedInUser;

  void login(User user) {
    _loggedInUser = user;
    notifyListeners();
  }

  void logout() {
    _loggedInUser = null;
    notifyListeners();
  }
}
