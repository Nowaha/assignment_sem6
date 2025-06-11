import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/screens/login.dart';
import 'package:assignment_sem6/screens/settings.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const String routeName = "/";

  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget element(User user) {
    return Text("${user.uuid} ${user.firstName} ${user.lastName}");
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final user = authState.getCurrentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Semester 6"),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              context.goNamed(SettingsPage.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Text("Hello, ${user.firstName}!"),
                  Text("Role: ${user.role.name}"),
                  TextButton(
                    onPressed: () {
                      authState.logout();
                      context.goNamed(LoginPage.routeName);
                    },
                    child: Text("Log out"),
                  ),
                ],
              ),
    );
  }
}
