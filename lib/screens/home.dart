import 'package:assignment_sem6/data/entity/impl/user.dart';
import 'package:assignment_sem6/screens/login/login.dart';
import 'package:assignment_sem6/screens/settings.dart';
import 'package:assignment_sem6/state/authstate.dart';
import 'package:assignment_sem6/widgets/screen.dart';
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

    return Screen.center(
      title: const Text("Home"),
      appBarActions: <Widget>[
        IconButton(
          onPressed: () {
            context.goNamed(SettingsPage.routeName);
          },
          icon: const Icon(Icons.settings),
        ),
      ],
      floatingActionButton: FloatingActionButton(
        tooltip: "Create a new post",
        onPressed: () {
          context.go("/post/create");
        },
        child: const Icon(Icons.add),
      ),
      child:
          user == null
              ? CircularProgressIndicator()
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
                  TextButton(
                    onPressed: () {
                      context.go("/post/randomPostId");
                    },
                    child: Text("View post"),
                  ),
                ],
              ),
    );
  }
}
